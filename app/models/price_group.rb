# frozen_string_literal: true

class PriceGroup < ApplicationRecord
  # attr_accessible :name, :price

  validates :name, :price, presence: true
  validates :price, numericality: { only_integer: true }

  belongs_to :event, optional: true
end
