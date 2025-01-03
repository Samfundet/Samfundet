# frozen_string_literal: true

class Area < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :page

  has_many :standard_hours

  accepts_nested_attributes_for :standard_hours

  validates_presence_of :name

  default_scope { includes(:page) }

  def today
    standard_hours.today.first
  end

  def by_day(day)
    standard_hours.find { |o| o.day == day }
  end

  def week
    StandardHour::WEEKDAYS.map do |day|
      standard_hours.find { |o| o.day == day } || standard_hours.build(day: day)
    end
  end

  def to_s
    name
  end

  def edit_path
    edit_area_path(self)
  end

  # Returns a list of open hours grouped by same days
  def grouped_open_hours
    open_hours = []
    start_day = nil
    end_day = nil
    current_period = nil

    standard_hours.sort.each_with_index do |o, i|
      if not o.open?
        period = 'Stengt'
      else
        period = I18n.l(o.open_time, format: :time) + ' - ' + I18n.l(o.close_time, format: :time)
      end

      # Track day
      if start_day == nil
        start_day = o.day
        current_period = period
      end

      # Previous group ended, add it
      if period != current_period
        day = I18n.t("days.#{start_day}")
        if end_day != nil
          day += ' - ' + I18n.t("days.#{end_day}")
        end
        # Hverdager custom string
        if start_day == 'monday' and end_day == 'friday'
          day = 'Hverdager'
        end
        open_hours.append([day, current_period])
        current_period = period
        start_day = o.day
        end_day = nil
      end

      # Update period end
      if start_day != o.day
        end_day = o.day
      end

      # Last day closes period
      if i >= standard_hours.count - 1
        day = I18n.t("days.#{start_day}")
        if end_day != nil
          day += ' - ' + I18n.t("days.#{o.day}")
        end
        open_hours.append([day, current_period])
      end
    end

    open_hours
  end

  def open_now?
    today&.open_now?
  end

  def earliest_open_time
    standard_hours.open_today.minimum(:open_time)
  end

  def latest_close_time
    standard_hours.open_today.map(&:adjusted_close_time).max
  end
end

# == Schema Information
#
# Table name: areas
#
#  id          :bigint           not null, primary key
#  name        :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  page_id     :integer
#
