# frozen_string_literal: true

class Sulten::Table < ApplicationRecord
  has_many :table_reservation_types
  has_many :reservation_types, through: :table_reservation_types
  has_many :reservations

  # What is this terrifying creature you may ask?
  # These relationships define the neighbour tables which are bi-directional and single model.
  # (eg. if A is neighbour of B then B is also neighbour of A)
  # In order to model a many-to-many relationship on the same model
  # we need to consider two cases, where the join table (sulten_neighbour_tables) is
  # (my_id, other_id) and (other_id, my_id). These relations define the (id, id) associations and the
  # :through fetches the actual table models.
  has_many :left_neighbour_associations, :foreign_key => :table_id,
           :class_name => "NeighbourTable",
           dependent: :destroy # Destroy relation if table is destroyed
  has_many :left_neighbours, :through => :left_neighbour_associations,
           :source => :neighbour

  has_many :right_neighbour_associations, :foreign_key => :neighbour_id,
           :class_name => "NeighbourTable",
           dependent: :destroy # Destroy relation if table is destroyed
  has_many :right_neighbours, :through => :right_neighbour_associations,
           :source => :table

  # attr_accessible :number, :capacity, :available, :comment, :reservation_type_ids, :neighbour_tables

  validates :number, :capacity, presence: true
  validates :number, uniqueness: true

  scope :tables_with_i_reservation_types, ->(i) { select { |t| t.reservation_types.size == i } }

  def to_s
    number
  end

  # Fetches the table records for neighbour tables
  def neighbours
    (left_neighbours + right_neighbours).flatten.uniq
  end

  def is_neighbour?(tbl_id)
    # Safety check for stack overflow
    # Self is newer considered a neighbour
    if tbl_id == id
      return false
    end
    neighbours.map { |n| n.id }.include?(tbl_id)
  end

  def neighbour_string
    if neighbours.count == 0
      "-"
    else
      neighbour_numbers = []
      neighbours.each do |n|
        neighbour_numbers << Sulten::Table.find(n.id).number
      end
      neighbour_numbers.join(", ")
    end
  end

end

# == Schema Information
#
# Table name: sulten_tables
#
#  id         :bigint           not null, primary key
#  number     :integer
#  capacity   :integer
#  comment    :text
#  available  :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
