# frozen_string_literal: true

class Sulten::ReservationType < ApplicationRecord
  has_many :reservations
  has_many :tables, through: :table_reservation_types

  def to_s
    name
  end
end

# == Schema Information
#
# Table name: sulten_reservation_types
#
#  id          :bigint           not null, primary key
#  name        :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#
