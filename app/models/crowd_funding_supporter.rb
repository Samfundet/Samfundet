# frozen_string_literal: true

class CrowdFundingSupporter < ApplicationRecord
  enum supporter_type: %i[group student_union], _suffix: true
  validates :name, :amount, :supporter_type, :donors, presence: true
  validates :donors, numericality: { greater_than: 0 }
  validates :amount, numericality: { greater_than_or_equal_to: 0 }
end
