module Api
  class EventsController < APIController
    def index
      @events = Event
        .active
        .published
        .upcoming
      page = params[:page].present? ? params[:page].to_i : 0
      render json: paginate(@events, page)
    end

    def create
      puts params
    end
  end

end
