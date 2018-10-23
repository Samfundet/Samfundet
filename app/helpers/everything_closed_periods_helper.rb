# frozen_string_literal: true

module EverythingClosedPeriodsHelper
  def samfundet_closed?
    EverythingClosedPeriod.current_period
  end
end
