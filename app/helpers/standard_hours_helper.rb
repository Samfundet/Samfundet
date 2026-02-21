module StandardHoursHelper
  def cache_key_for_standard_hours
    count = StandardHour.count

    max_updated_at = StandardHour.maximum(:updated_at)&.utc

    max_updated_at_str =
      if max_updated_at.nil?
        nil
      elsif max_updated_at.respond_to?(:to_fs)
        # ActiveSupport/Rails: format-aware string conversion
        max_updated_at.to_fs(:number)
      elsif max_updated_at.respond_to?(:to_s) && max_updated_at.method(:to_s).arity != 0
        # Only call with format if `to_s` accepts an argument
        max_updated_at.to_s(:number)
      else
        # Fallback
        max_updated_at.to_s
      end

    current_day = (Time.current - 4.hours)

    closed = EverythingClosedPeriod.current_period

    "#{I18n.locale}-standard-hours/all-#{count}-#{max_updated_at_str}-#{current_day}-#{closed}"
  end
end
