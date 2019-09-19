# frozen_string_literal: true

class FrontPageHijack < ApplicationRecord
  # attr_accessible :message_no, :message_no, shown_from, shown_from
  validates :message_no, presence: true
  validates :message_en, presence: true
  validates :shown_from, presence: true
  validates :shown_to, presence: true
  validates :background_color, css_hex_color: true, presence: true
  validates :text_color, css_hex_color: true, presence: true
  validate :times_in_valid_order

  scope :active_hijacks, -> { where('shown_from <= ? AND shown_to >= ?', Time.current, Time.current.yesterday) }
  scope :current_and_future_front_page_hijacks, -> { where('shown_to >= ?', Time.current.yesterday) }
  extend LocalizedFields
  localized_fields :message

  def self.current_front_page_hijack
    active_hijacks.last
  end

  def times_in_valid_order
    unless shown_from < shown_to
      errors.add(:shown_to, I18n.t('front_page_hijack.times_in_valid_order'))
    end
  end
end
