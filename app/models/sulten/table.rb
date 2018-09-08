# frozen_string_literal: true

class Sulten::Table < ApplicationRecord
  has_many :reservation_types, through: :table_reservation_types
  has_many :table_reservation_types
  has_many :reservations

  # attr_accessible :number, :capacity, :available, :comment, :reservation_type_ids

  validates :number, :capacity, presence: true
  validates :number, uniqueness: true

  scope :tables_with_i_reservation_types, ->(i) { select { |t| t.reservation_types.size == i } }

  def to_s
    number
  end
end
