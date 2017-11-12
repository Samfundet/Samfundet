# frozen_string_literal: true

module StandardHoursHelper
  def cache_key_for_standard_hours
    count          = StandardHour.count

    max_updated_at = StandardHour
                     .maximum(:updated_at)
                     .try(:utc)
                     .try(:to_s, :number)
    current_day = (Time.current - 4.hours)

    closed = EverythingClosedPeriod.current_period

    "#{I18n.locale}-standard-hours/all-#{count}-#{max_updated_at}-#{current_day}-#{closed}"
  end
end
