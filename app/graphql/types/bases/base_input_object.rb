# frozen_string_literal: true

module Types
  module Bases
    class BaseInputObject < GraphQL::Schema::InputObject
      argument :id, Integer, required: false
    end
  end
end
