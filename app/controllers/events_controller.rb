# -*- encoding : utf-8 -*-
class EventsController < ApplicationController
  filter_access_to [:admin], require: :edit
  filter_access_to [:purchase_callback_failure,
                    :purchase_callback_success], require: :buy
  filter_access_to :rss, require: :read

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :events }

  before_filter :set_organizer_id, only: [:create, :update]

  def set_organizer_id
    case params[:event][:organizer_type]
    when Group.name
      params[:event][:organizer_id] = params[:event][:organizer_group_id]
    when ExternalOrganizer.name
      params[:event][:organizer_id] = ExternalOrganizer.find_or_create_by_name(params[:event][:organizer_external_name]).id
    end

    params[:event].delete(:organizer_group_id)
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
              .text_search(params[:search])

    render '_search_results', layout: false if request.xhr?
  end

  def show
    @event = Event.find(params[:id])
  end

  def new
    @event = Event.new(
      non_billig_start_time: Time.current + 1.hour,
      publication_time: Time.current)
  end

  def create
    @event = Event.new(params[:event])
    if @event.save
      if @event.non_billig_start_time < Time.current
        flash[:message] = t('events.time_of_start_has_passed')
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
    if @event.update_attributes(params[:event])
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
    @event.destroy
    flash[:success] = t('events.destroy_success')
    redirect_to events_path
  end

  def buy
    @event = Event.find(params[:id])

    unless @event.purchase_status == Event::TICKETS_AVAILABLE
      raise ActionController::RoutingError.new('Not Found') if request.xhr?

      flash[:error] = t('events.can_not_purchase_error')
      redirect_to(@event) && return
    end

    @ticket_groups = @event.billig_event.netsale_billig_ticket_groups

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
    @events = Event.past
                   .paginate(page: params[:page], per_page: 20)
                   .order("non_billig_start_time DESC")
  end

  def admin_applet
  end

  def purchase_callback_success
    split_tickets = params[:tickets]
                    .split(",")
                    .map(&:to_i)
                    .uniq - [0]

    @references = split_tickets.join(", ") << "."
    @pdf_url = Rails.application.config.billig_ticket_path.dup
    @sum = 0

    @ticket_event_price_group_card_no =
        split_tickets.each_with_index.map do |ticket_with_hmac, i|
          ticket_id = ticket_with_hmac.to_s[0..-6].to_i # First 5 characters are hmac.
          @pdf_url << "ticket#{i}=#{ticket_with_hmac}&"
          billig_ticket = BilligTicket.find_by_ticket(ticket_id)

          if billig_ticket
            @sum += billig_ticket.billig_price_group.price

            card_number = if billig_ticket.on_card
                            billig_ticket.billig_purchase.membership_card.card
                          end

            [billig_ticket,
             billig_ticket.billig_event,
             billig_ticket.billig_price_group,
             card_number]
          end
        end.compact

    @pdf_url.chop! # Remove last '&' character.
  end

  def purchase_callback_failure
    payment_error = BilligPaymentError.where(error: params[:bsession]).first

    if payment_error.blank? # Error case no. 1: Database error.
      flash[:error] = t('events.purchase_generic_error')
      redirect_to root_path
    else
      payment_error_price_group =
        BilligPaymentErrorPriceGroup.where(error: params[:bsession]).first

      if payment_error_price_group.present? # Error case no. 3. Field errors.
        event = payment_error_price_group.samfundet_event
        redirect_to buy_event_path(event, bsession: params[:bsession])
      else # Error case no. 2. Show payment error without purchase form.
        flash[:error] = payment_error.message
        redirect_to root_path
      end
    end
  end

  def ical
    @events = Event.upcoming.active.published
  end

  def rss
    @events = if %w(archive arkiv).include? params[:type]
                Event.active.published
              else
                Event.upcoming.active.published
              end
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end
