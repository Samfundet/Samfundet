# frozen_string_literal: true

class PriceGroup < ApplicationRecord
  # attr_accessible :name, :price

  validates :name, :price, presence: true
  validates :price, numericality: { only_integer: true }

  belongs_to :event
end

# == Schema Information
#
# Table name: price_groups
#
#  id         :bigint           not null, primary key
#  name       :string
#  price      :integer
#  event_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
