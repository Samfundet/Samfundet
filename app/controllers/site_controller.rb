# frozen_string_literal: true

class SiteController < ApplicationController
  skip_authorization_check


  def index
    @todays_events = Event.today
    @upcoming_events = Event.front_page_events(11)
    @banner_event = @upcoming_events.shift

    @info_boxes = {}
    InfoBox.where('start_time <= ? and end_time >= ?', Time.current, Time.current).each do |box|
      if @info_boxes[box.position] == nil
        @info_boxes[box.position] = [box]
      else
        @info_boxes[box.position].append(box)
      end
    end

    @opening_hours_url = page_url(Page.find_by_name(t('site.index.opening-hours-page-title')))
    open_admissions = Admission.appliable.includes(
        group_types: { groups: :jobs }
    )
    if open_admissions and not open_admissions.empty?
      @open_admission = true
    else
      @open_admission = false
    end

    # Catch session token for ticket purchase errors redirecting to index
    if params[:bsession].present?
      payment_error = BilligPaymentError.where(error: params[:bsession]).first
      if payment_error.blank?
        flash[:error] = t('events.purchase_generic_error')
      else
        flash[:error] = payment_error.message
      end
    end
  end

  def brochure
    pdf_filename = File.join(Rails.root, 'app/assets/files/Brosjyre.pdf')
    send_file(pdf_filename, filename: 'samfundet-brosjyre.pdf', disposition: 'inline', type: 'application/pdf')
  end

  def generic_redirect
    redirect_to "https://no.surveymonkey.com/r/samfundet-valgundersokelse"
  end

end
