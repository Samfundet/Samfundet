# frozen_string_literal: true

class StandardHour < ApplicationRecord
  belongs_to :area

  WEEKDAYS = %w[monday tuesday wednesday thursday friday
                saturday sunday].freeze

  validates :day, inclusion: { in: WEEKDAYS, message: 'Invalid weekday' }
  validates :day, :area, presence: true
  validates :open_time, :close_time, presence: { if: :open? }
  validates :day, uniqueness: { scope: :area_id }

  # attr_accessible :close_time, :open_time, :day, :open

  scope :open_today, -> { today.where(open: true) }

  scope :today, lambda {
    where(day: (Time.current - 4.hours).strftime('%A').downcase)
  }

  def open_now?
    now = Time.current
    open_time_today = Time.parse(open_time.strftime('%H:%M:%S'))
    close_time_today = Time.parse(close_time.strftime('%H:%M:%S'))
    open && now >= open_time_today && now <= close_time_today
  end

  def adjusted_close_time
    # Adjust for times that go past midnight
    if close_time < open_time
      close_time + 1.day
    else
      close_time
    end
  end
end

# == Schema Information
#
# Table name: standard_hours
#
#  id         :bigint           not null, primary key
#  open       :boolean
#  open_time  :time
#  close_time :time
#  area_id    :integer
#  day        :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
