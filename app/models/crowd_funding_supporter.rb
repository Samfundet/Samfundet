# frozen_string_literal: true

class CrowdFundingSupporter < ApplicationRecord

  enum supporter_type: [:group, :student_union], _suffix: true

  validates :name, :amount, :supporter_type, presence: true

end
