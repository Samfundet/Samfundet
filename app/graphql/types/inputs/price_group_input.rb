# frozen_string_literal: true
#
module Types
  module Inputs
    class PriceGroupInput < GraphQL::Schema::InputObject
      argument :name, String, required: true
      argument :price, Integer, required: true
    end
  end
end
