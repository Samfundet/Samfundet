# frozen_string_literal: true

class Sulten::NeighbourTable < ApplicationRecord
  belongs_to :table
  belongs_to :neighbour
end

