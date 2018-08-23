# frozen_string_literal: true

class SiteController < ApplicationController
  after_action :check_active_notifications
  def index
    @todays_events = Event.today
    @upcoming_events = Event.front_page_events(11)
    @banner_event = @upcoming_events.shift
  end

  def check_active_notifications
    register_membership = t('site.notifications.membership.welcome') +
                     t('site.notifications.membership.click') +
                     "#{view_context.link_to(t('site.notifications.membership.to_url'), 'https://medlem.samfundet.no')}" +
                     t('site.notifications.membership.register')
    flash_in_date_range 8, 9, register_membership
  end

  def flash_in_date_range(from_month, to_month, message)
    current_month = Time.now.strftime("%m").to_i
    if current_month.between?(from_month, to_month)
      flash[:notice] = message.html_safe
    end
  end
end
