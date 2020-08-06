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
  end

  def menu

  end

  def about

  end

  def contact

  end

end

