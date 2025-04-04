# frozen_string_literal: true

class EventsController < ApplicationController
  load_and_authorize_resource
  has_control_panel_applet :admin_applet,
                           if: -> { can? :edit, Event }

  skip_before_action :verify_authenticity_token, only: %i[search archive_search]
  before_action :set_organizer_id, only: %i[create update]

  def set_organizer_id
    case params[:event][:organizer_type]
    when ExternalOrganizer.name
      params[:event][:organizer_id] = ExternalOrganizer.find_or_create_by(name: params[:event][:organizer_external_name]).id
    end

    params[:event].delete(:organizer_external_name)
  end

  def index
    @events = Event
                .active
                .published
                .upcoming
  end

  def search
    @events = Event
                .active
                .published
                .upcoming
                .text_search(params[:search])

    render '_search_results', layout: false if request.xhr?
  end

  def archive_search
    # Save the search parameters as instance variables
    # Convert each param to string in case it is nil
    @search = params[:search].to_s
    @event_type = params[:event_type].to_s
    @event_area = params[:event_area].to_s

    @events, @event_types, @event_areas = Event.archived_events_types_areas
    @events = @events.text_search(@search + ' ' + @event_type + ' ' + @event_area)

    if @events.empty?
      redirect_to archive_events_path

      # Only display error message if one or more search parameters are present
      if @search.present? || @event_type.present? || @event_area.present?
        flash[:error] = t('search.no_results')
      end
    else
      # Only paginate if there are results to display

      # Set page to 1 if page input is invalid
      params[:page] = Integer(params[:page]) rescue 1
      @events = @events.paginate(page: params[:page], per_page: 20)
      render '_archive_list', locals: { search_active: true }
    end
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new(
      non_billig_start_time: Time.current + 1.hour,
      publication_time: Time.current
    )
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      if @event.non_billig_start_time < Time.current
        flash[:message] = t('events.time_of_start_has_passed')
      end
      if @event.price_type.eql? 'free_registration'
        @capacity = Integer(event_params[:capacity]) rescue nil
        # Prevent users from creating registration events without capacity
        if @capacity.nil?
          @event.destroy
          flash[:error] = t('events.create_error_capacity')
          render :new
          return
        end
        @registration_event = RegistrationEvent.create(arrangement: @event, plasser: @capacity)
      end
      flash[:success] = t('events.create_success')
      redirect_to @event
    else
      flash.now[:error] = t('events.create_error')
      render :new
    end
  end

  def edit
    @event = Event.find params[:id]
  end

  def update
    @event = Event.find params[:id]
    if @event.update(event_params)
      if (@event.price_type.eql? 'free_registration') && @event.registration_event.nil?
        @capacity = Integer(event_params[:capacity]) rescue 0
        @registration_event = RegistrationEvent.create(arrangement: @event, plasser: @capacity)
      end
      if @event.non_billig_start_time < Time.current
        flash[:message] = t('events.time_of_start_has_passed')
      end
      flash[:success] = t('events.update_success')
      redirect_to @event
    else
      flash.now[:error] = t('events.update_error')
      render :edit
    end
  end

  def destroy
    @event = Event.find(params[:id])
    if @event.price_type.eql?('free_registration') && @event.registration_event
      @event.registration_event.destroy
    end
    @event.destroy
    flash[:success] = t('events.destroy_success')
    redirect_to events_path
  end

  def buy
    @event = Event.find(params[:id])

    unless @event.codeword.empty?
      if params[:codeword].nil?
        flash[:error] = t('events.please_enter_codeword')
        redirect_to(@event) && return
      elsif @event.codeword != params[:codeword]
        flash[:error] = t('events.wrong_codeword')
        redirect_to(@event) && return
      end
    end

    unless @event.purchase_status == Event::TICKETS_AVAILABLE
      raise ActionController::RoutingError, 'Not Found' if request.xhr?

      flash[:error] = t('events.can_not_purchase_error')
      redirect_to(@event) && return
    end

    @ticket_groups = @event.billig_event.netsale_billig_ticket_groups

    # Check if non-member tickets available (to show email purchase option)
    @non_member_ticket_available = @event.billig_event.has_non_member_tickets?

    if params.key? :bsession
      @payment_error = BilligPaymentError.where(error: params[:bsession]).first
      @payment_error_price_groups =
        Hash[BilligPaymentErrorPriceGroup.where(error: params[:bsession])
               .map { |bpepg| [bpepg.price_group, bpepg.number_of_tickets] }]
      flash.now[:error] = @payment_error.message
    else
      @payment_error = nil
      @payment_error_price_groups = {}
    end

    render layout: false if request.xhr?
  end

  def admin
    @events = Event.upcoming.order(:non_billig_start_time)
  end

  def archive
    @events, @event_types, @event_areas = Event.archived_events_types_areas
    # Set page to 1 if page input is invalid
    params[:page] = Integer(params[:page]) rescue 1
    @events = @events.paginate(page: params[:page], per_page: 20)
  end

  def admin_applet
  end

  def purchase_callback_success
    split_tickets = params[:tickets]
                      .split(',')
                      .map(&:to_i)
                      .uniq - [0]

    @google_form_enabled = Rails.application.config.purchase_callback_google_form_enabled
    @google_form_url = Rails.application.config.purchase_callback_google_form_url

    @references = split_tickets.join(', ') << '.'
    @pdf_url = Rails.application.config.billig_ticket_path.dup
    @sum = 0

    @ticket_event_price_group_card_no =
      split_tickets.each_with_index.map do |ticket_with_hmac, i|
        ticket_id = ticket_with_hmac.to_s[0..-6].to_i # First 5 characters are hmac.
        @pdf_url << "ticket#{i}=#{ticket_with_hmac}&"
        billig_ticket = BilligTicket.find(ticket_id)

        next unless billig_ticket
        @sum += billig_ticket.billig_price_group.price

        card_number = if billig_ticket.on_card
                        billig_ticket.billig_purchase.membership_card.card
                      end

        [billig_ticket,
         billig_ticket.billig_event,
         billig_ticket.billig_price_group,
         card_number]
      end.compact

    @pdf_url.chop! # Remove last '&' character.
  end

  def purchase_callback_failure
    payment_error = BilligPaymentError.where(error: params[:bsession]).first

    if payment_error.blank? # Error case no. 1: Database error.
      flash[:error] = t('events.purchase_generic_error')
      payment_error_price_group = BilligPaymentErrorPriceGroup.where(error: params[:bsession]).first
      if payment_error_price_group.present? # Error case no. 3. Field errors.
        event = payment_error_price_group.samfundet_event
        redirect_to buy_event_path(event, bsession: params[:bsession])
      else
        redirect_to root_path(bsession: params[:bsession])
      end
    else
      payment_error_price_group = BilligPaymentErrorPriceGroup.where(error: params[:bsession]).first
      if payment_error_price_group.present? # Error case no. 3. Field errors.
        event = payment_error_price_group.samfundet_event
        redirect_to buy_event_path(event, bsession: params[:bsession])
      else # Error case no. 2. Show payment error without purchase form.
        redirect_to root_path(bsession: params[:bsession])
      end
    end
  end

  def ical
    @event_type = params[:event_type].to_s
    if @event_type.empty?
      @events = Event.upcoming.active.published
    else
      @events = Event.upcoming.active.published.where(event_type: @event_type)
    end
  end

  def rss
    @events = if %w[archive arkiv].include? params[:type]
                Event.active.published
              else
                Event.upcoming.active.published
              end
    respond_to do |format|
      format.rss { render layout: false }
    end
  end

private

  def event_params
    params.require(:event).permit(
      :non_billig_title_no,
      :title_en,
      :short_description_en,
      :short_description_no,
      :long_description_en,
      :long_description_no,
      :event_type,
      :age_limit,
      :area_id,
      :status,
      :image_id,
      :primary_color,
      :secondary_color,
      :banner_alignment,
      :organizer_type,
      :non_billig_start_time,
      :duration,
      :publication_time,
      :spotify_uri,
      :facebook_link,
      :youtube_link,
      :youtube_embed,
      :soundcloud_link,
      :instagram_link,
      :twitter_link,
      :lastfm_link,
      :vimeo_link,
      :general_link,
      :price_type,
      :billig_event_id,
      :organizer_id,
      :codeword,
      :registration_link,
      :capacity,
      :external_organizer_link,
      price_groups_attributes: %i(name price id _destroy)
    )
  end
end
