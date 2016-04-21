# -*- encoding : utf-8 -*-
module EverythingClosedPeriodsHelper
  def samfundet_closed?
    EverythingClosedPeriod.current_period
  end
end
