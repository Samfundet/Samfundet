# frozen_string_literal: true

class ProductVariation < ApplicationRecord
  validates :product_id, :name, :amount, presence: true

  belongs_to :product
  has_many :order_products, dependent: :destroy

  def to_s
    name
  end
end
