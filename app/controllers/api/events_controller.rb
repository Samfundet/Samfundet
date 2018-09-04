module Api
  class EventsController < APIController
    def index
      @events = Event.all
      render json: @events
    end
  end
end
