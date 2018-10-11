# frozen_string_literal: true

class Types::BaseInputObject < GraphQL::Schema::InputObject
  argument :id, Integer, required: false
end
