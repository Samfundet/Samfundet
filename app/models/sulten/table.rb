require 'csv'

class Sulten::Table < ActiveRecord::Base
  has_many :reservation_types, through: :table_reservation_types
  has_many :table_reservation_types
  has_many :reservations

  attr_accessible :number, :capacity, :available, :comment, :reservation_type_ids

  validates_presence_of :number, :capacity
  validates_uniqueness_of :number

  scope :tables_with_i_reservation_types, lambda { |i| select { |t| t.reservation_types.size == i } }

  def to_s
    number
  end



end
