class InfoscreenController < ApplicationController
    skip_authorization_check
    layout :nil

    def index
        @events = Event.all
        @areas = Area.all

        @current_event = Event.first
    end
end
