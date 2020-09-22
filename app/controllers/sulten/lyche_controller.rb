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
    @available_times = Sulten::Reservation.find_available_times(params[:date], params[:duration].to_i, params[:people].to_i, params[:type_id].to_i)
    puts(@available_times)
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

