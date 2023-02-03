# frozen_string_literal: true

class ProductVariation < ApplicationRecord
  validates :specification, :quantity, presence: true

  belongs_to :product

  def to_s
    specification
  end
end
