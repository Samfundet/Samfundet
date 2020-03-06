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
    flash_in_date_range = lambda { |date_from, date_to, date_type, msg|
      time_now = Time.now.strftime(date_type).to_i
      return unless time_now.between?(date_from, date_to)
      flash[:notice] = view_context.sanitize(msg)
    }

    def context_ext_url(context = nil, name = nil, options = nil, html_options = {}, &block)
      html_options[:target] = '_blank'
      html_options[:rel] = 'nofollow, noindex, noreferrer'
      context.link_to(name, options, html_options, &block)
    end

    msg1 = t('site.index.sit_samf_series1')

    link = context_ext_url(view_context,
                            t('site.index.sit_samf_series2'),
                            'https://www.youtube.com/watch?v=YRnxoMCZwI8')

    msg2 = t('site.index.sit_samf_series3')
    message = [msg1, link, msg2].join(' ')
    flash_in_date_range.call(3, 5, '%m', message)
  end
end
