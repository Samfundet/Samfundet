# frozen_string_literal: true

class OrderProduct < ApplicationRecord
  validates :amount, presence: true

  belongs_to :order
  belongs_to :product, optional: true
  belongs_to :product_variation, optional: true
end
