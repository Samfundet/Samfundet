# frozen_string_literal: true

class Sulten::TableReservationType < ApplicationRecord
  belongs_to :table
  belongs_to :reservation_type
end
