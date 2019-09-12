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

    # add all notifications below, call the flashes after each
    #register_membership =
    #  t('site.notifications.membership.welcome') + ' ' +
    #  t('site.notifications.membership.click') + ' ' +
    #  view_context.link_to(t('site.notifications.membership.to_url'), 'https://medlem.samfundet.no') + ' ' +
    #  t('site.notifications.membership.register')
    #flash_in_date_range.call(8, 9, '%m', register_membership)

    building_period = t('site.notifications.membership.building_period1') + ' ' + view_context.link_to(t('site.notifications.membership.uka'), 'https://www.uka.no/') + ' ' + t('site.notifications.membership.building_period2')
    flash_in_date_range.call(8, 9, '%m', building_period)
  end
end
