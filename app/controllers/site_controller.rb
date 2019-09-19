# frozen_string_literal: true

class SiteController < ApplicationController
  skip_authorization_check

  def index
    @todays_events = Event.today
    @upcoming_events = Event.front_page_events(11)
    @banner_event = @upcoming_events.shift
    @front_page_hijack = FrontPageHijack.current_front_page_hijack
  end
end
