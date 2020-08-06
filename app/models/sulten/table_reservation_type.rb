# frozen_string_literal: true

class Sulten::TableReservationType < ApplicationRecord
  belongs_to :table
  belongs_to :reservation_type
end

# == Schema Information
#
# Table name: sulten_table_reservation_types
#
#  id                  :bigint           not null, primary key
#  table_id            :integer
#  reservation_type_id :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
