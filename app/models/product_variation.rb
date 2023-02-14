# frozen_string_literal: true

class ProductVariation < ApplicationRecord
  validates :product_id, :specification, :quantity, presence: true

  belongs_to :product

  def to_s
    specification
  end
end
