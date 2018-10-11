# frozen_string_literal: true

class Types::BaseObject < GraphQL::Schema::Object
  field :id, Integer, null: false
end
