# frozen_string_literal: true

class ProductVariation < ApplicationRecord
  validates :product_id, :specification, :quantity, presence: true

  belongs_to :product
  has_many :order_products, dependent: :destroy

  def to_s
    specification
  end
end
