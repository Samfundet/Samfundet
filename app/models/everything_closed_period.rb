# frozen_string_literal: true

class EverythingClosedPeriod < ApplicationRecord
  # attr_accessible :message_no, :message_en, :event_message_no, :event_message_en, :closed_from, :closed_to

  validates :message_no, presence: true
  validates :message_en, presence: true
  validates :event_message_no, presence: true
  validates :event_message_en, presence: true
  validates :closed_from, presence: true
  validates :closed_to, presence: true
  validate :times_in_valid_order

  scope :active_closed_periods, -> { where('closed_from <= ? AND closed_to >= ?', Time.current, Time.current.yesterday) }
  scope :current_and_future_closed_times, -> { where('closed_to >= ?', Time.current.yesterday) }

  extend LocalizedFields
  localized_fields :message
  localized_fields :event_message

  def self.current_period
    active_closed_periods.first
  end

  def times_in_valid_order
    unless closed_from < closed_to
      errors.add(:closed_to, I18n.t('everything_closed_periods.times_in_valid_order'))
    end
  end
end

# == Schema Information
#
# Table name: everything_closed_periods
#
#  id               :bigint           not null, primary key
#  message_no       :text
#  closed_from      :datetime
#  closed_to        :datetime
#  message_en       :text
#  event_message_no :text
#  event_message_en :text
#
