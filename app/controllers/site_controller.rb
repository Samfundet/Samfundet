# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class SiteController < ApplicationController
  def index
    @todays_events = Event.today
    @upcoming_events = Event.front_page_events(11)
    @banner_event = @upcoming_events.shift
  end
end
