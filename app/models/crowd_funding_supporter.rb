# frozen_string_literal: true

class CrowdFundingSupporter < ApplicationRecord
  enum supporter_type: %i[group student_union], _suffix: true
  validates :name, :amount, :supporter_type, :donors, presence: true
  validates :donors, numericality: { greater_than: 0 }
  def per_donor(supporter)
    supporter.amount.to_f / supporter.donors
  end
end
