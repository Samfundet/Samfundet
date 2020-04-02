# frozen_string_literal: true

class Sulten::ClosedPeriod < ApplicationRecord
  # attr_accessible :message_no, :message_en, :event_message_no, :event_message_en, :closed_from, :closed_to

  validates :closed_from, presence: true
  validates :closed_to, presence: true
  validate :times_in_valid_order

  scope :previous_closed_periods, -> { where('closed_to < ?', Time.current.yesterday) }
  scope :active_closed_periods, -> { where('closed_from <= ? AND closed_to >= ?', Time.current, Time.current.yesterday) }
  scope :current_and_future_closed_times, -> { where('closed_to >= ?', Time.current.yesterday) }

  extend LocalizedFields
  localized_fields :message

  def self.current_period
    active_closed_periods.first
  end

  def times_in_valid_order
    errors.add(:closed_to, I18n.t('sulten.closed_periods.times_in_valid_order')) unless closed_from <= closed_to
  end
end

# == Schema Information
#
# Table name: sulten_closed_periods
#
#  id          :bigint           not null, primary key
#  message_no  :string
#  message_en  :string
#  closed_from :datetime
#  closed_to   :datetime
#
