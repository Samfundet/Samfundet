# frozen_string_literal: true

class Order < ApplicationRecord
  validates :epost, :name, presence: true

  has_many :order_products, dependent: :destroy
end
