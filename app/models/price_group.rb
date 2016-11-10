class PriceGroup < ActiveRecord::Base
  # attr_accessible :name, :price

  validates :name, :price, presence: true
  validates :price, numericality: { only_integer: true }

  belongs_to :event
end
