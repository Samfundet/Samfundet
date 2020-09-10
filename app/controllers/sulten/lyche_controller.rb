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
    unless @closed_periods.empty?
      @closed_periods = [@closed_periods.first]
    end
    @reservation = Sulten::Reservation.new
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

