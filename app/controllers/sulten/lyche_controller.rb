# frozen_string_literal: true

# Controller for redesigned Lyche page
# samfundet.no/lyche

class Sulten::LycheController < Sulten::BaseController
    skip_authorization_check
    layout "lyche"

    def index

    end

    def reservation

      @closed_periods = Sulten::ClosedPeriod.current_and_future_closed_times.sort_by(&:closed_from)
      @reservation = Sulten::Reservation.new

    request = params[:sulten_reservation]

    if not request.nil?
      #The amount of people is for now stored in the reservation_duration parameter!
      #This is because of the dropdown menu feature, for selecting the amount of people
      #Should be changed to :people later, but needs to be changed in other files as well
      amount_people = request[:reservation_duration].to_i

      available_times = Sulten::Reservation.find_available_times(request[:reservation_from], amount_people, request[:reservation_type_id].to_i)
      @times = available_times.map { |a| a.strftime("%H:%M") }
      @reservation_type = request[:reservation_type_id]
      @number_of_guests = request[:reservation_duration] #Using the reservation_duration to get a dropdown.
      puts("jjj", @number_of_guests)
      @reservation_date = request[:reservation_from]
    end
  end

  def reservation_success

  end

  def reservation_failure

  end

  # Shown when reservation fails due to not being one day in future
  def reservation_failure_day

  end

  def menu

  end

  def about

  end

  def contact

  end

end

