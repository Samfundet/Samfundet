class InfoscreenController < ApplicationController
    skip_authorization_check
    layout :nil

    def index
        @events = Event.all
        @areas = Area.all
    end
end
