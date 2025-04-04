# frozen_string_literal: true

# Controller for redesigned Lyche page
# samfundet.no/lyche

class Sulten::LycheController < Sulten::BaseController
  skip_authorization_check
  layout 'lyche'
  before_action :check_food_open, only: %i[index reservation]

  def index
    # Check if in closed period
    @closed = nil
    closed_periods = Sulten::ClosedPeriod.current_and_future_closed_times.sort_by(&:closed_from)
    unless closed_periods.empty?
      if closed_periods.first.closed_from < Time.now and closed_periods.first.closed_to + 1.days > Time.now
        @closed = closed_periods.first
      end
    end

    area = Area.find_by_name('Lyche')
    if area == nil
      @open_hours = []
    else
      @open_hours = area.grouped_open_hours
    end
  end

  def check_food_open
    @food_open_date = Date.parse('17.08.2023')
    @food_closed = false
    if @food_open_date > Time.now
      @food_closed = true
    end
  end

  def reservation
    @closed_periods = Sulten::ClosedPeriod.current_and_future_closed_times.sort_by(&:closed_from)
    @closed_periods.delete_if do |c|
      if (c.closed_from - Time.now) > 60.days
        true
      end
    end
    @reservation = Sulten::Reservation.new

    request = params[:sulten_reservation]

    if not request.nil?

      # Not tomorrow or later
      @must_be_in_future = false
      start = Date.parse(request[:reservation_from])
      if start < Date.tomorrow
        @must_be_in_future = true
        return
      end

      # Closed period
      @in_closed_period = false
      stop = Date.parse(request[:reservation_from])
      Sulten::ClosedPeriod.current_and_future_closed_times.each do |period|
        if (period.closed_from..(period.closed_to + 1.day)).cover? stop
          @in_closed_period = true
          return
        end
      end

      # Check if food is open, if food type is selected
      @in_food_closed_period = false
      @reservation_type = request[:reservation_type_id]
      reservation_type_name = Sulten::ReservationType.find_by(id: @reservation_type).name
      if reservation_type_name.include?('Mat') && @food_closed
        if stop < @food_open_date
          @in_food_closed_period = true
          return
        end
      end

      # The amount of people is for now stored in the reservation_duration parameter!
      # This is because of the dropdown menu feature, for selecting the amount of people
      # Should be changed to :people later, but needs to be changed in other files as well
      amount_people = request[:reservation_duration].to_i
      available_times = Sulten::Reservation.find_available_times(request[:reservation_from], amount_people, request[:reservation_type_id].to_i)
      @times = available_times.map { |a| a.strftime('%H:%M') }
      @number_of_guests = request[:reservation_duration] # Using the reservation_duration to get a dropdown.
      @reservation_date = request[:reservation_from]
      area = Area.find_by_name('Lyche')
      day = Time.parse(@reservation_date).strftime('%A').downcase
      @close_time = area.by_day(day).close_time
      @day = day

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
    area = Area.find_by_name('Lyche')
    @categories = Sulten::MenuCategory.includes(:sulten_menu_items).order(:order)
    if area == nil
      @open_hours = []
    else
      @open_hours = area.grouped_open_hours
    end
  end

  def about
  end

  def contact
  end
end
