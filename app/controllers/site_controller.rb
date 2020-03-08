# frozen_string_literal: true

class SiteController < ApplicationController
  skip_authorization_check
  before_action :check_active_notifications

  def index
    @todays_events = Event.today
    @upcoming_events = Event.front_page_events(11)
    @banner_event = @upcoming_events.shift
  end

private

  def check_active_notifications
    # from an dto are integers of date_type
    # some supported (most useful) types:
    #   %m - Month, e.g. 8 for August, 1 for January
    #   %d - Day in month
    #   %H - Hour of day
    flash_in_date_range = lambda { |date_from, date_to, msg, flash_type|
      time_now = Date.new()
      return unless time_now.between?(date_from, date_to)
      flash[:notice] = msg
    }

    valid_date = lambda {|from, to| Time.zone.today.between?(from, to)}

    start_msg = t('site.index.sit_samf_series1')
    link_text = t('site.index.sit_samf_series2')
    end_msg = t('site.index.sit_samf_series3')
    url = 'https://www.youtube.com/watch?v=YRnxoMCZwI8'
    external_url = "<br><br><a target=_'blank' rel='noopener noreferrer' href=#{url}>#{link_text}</a>"

    message = "#{start_msg} #{external_url} #{end_msg}"
    # message = Rails::Html::LinkSanitizer.new.sanitize(raw_html_message)
    # message = ApplicationController::Base.helpers.sanitize(raw_html)

    sit_start = Date.new(2020, 3, 6)
    sit_end = Date.new(2020, 4, 1)
    if valid_date.call(sit_start, sit_end)
      flash[:notice] = message.html_safe
    end

    ledervalg_start = Date.new(2020, 3, 6)
    ledervalg_slutt = Date.new(2020, 3, 10)
    if valid_date.call(ledervalg_start, ledervalg_slutt)
      flash[:message] = t("site.index.election")
    end
  end
end
