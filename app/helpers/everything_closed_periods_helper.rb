# -*- encoding : utf-8 -*-
module EverythingClosedPeriodsHelper
  def samfundet_closed?
    EverythingClosedPeriod.current_period
  end

  def samfundet_closed_message
    ecp = EverythingClosedPeriod.current_period
    I18n.t('everything_closed_periods.closed_message',
           closed_from: ecp.closed_from.to_date,
           closed_to: ecp.closed_to.to_date,
           message: ecp.message)
  end
end
