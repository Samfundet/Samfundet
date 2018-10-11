# frozen_string_literal: true

module Types
  class BaseInputObject < GraphQL::Schema::InputObject
    argument :id, Integer, required: false
  end
end
