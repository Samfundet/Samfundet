# frozen_string_literal: true

class Sulten::NeighbourTable < ApplicationRecord
  belongs_to :table, class_name: "Sulten::Table"
  belongs_to :neighbour, class_name: "Sulten::Table"

  def to_s
    table_id.to_s + ":" + neighbour_id.to_s
  end

end

