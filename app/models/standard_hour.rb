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
