# -*- encoding : utf-8 -*-
module StandardHoursHelper
  def cache_key_for_standard_hours
    count          = StandardHour.count

    max_updated_at = StandardHour
                     .maximum(:updated_at)
                     .try(:utc)
                     .try(:to_s, :number)
    current_day = Time.current.day

    closed = EverythingClosedPeriod.current_period

    "#{I18n.locale}-standard-hours/all-#{count}-#{max_updated_at}-#{current_day}-#{closed}"
  end
end
