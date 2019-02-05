# frozen_string_literal: true
module Types
  module Inputs
    class ReservationInput < Types::Bases::BaseInputObject
      argument :name, String, required: true do
        description 'Reservation holder name'
      end

      argument :email, String, required: true do
        description 'Reservation holder email'
      end

      argument :people, Integer, required: true do
        description 'The number of people coming'
      end

      argument :reservation_type_id, Integer, required: true do
        description '1 for food, 2 for drinks'
      end

      argument :telephone, String, required: true
      argument :reservation_from, GraphQL::Types::ISO8601DateTime, required: true
      argument :reservation_duration, String, required: true
      argument :allergies, String, required: false
    end
  end
end
