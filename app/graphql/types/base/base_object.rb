# frozen_string_literal: true

module Types
  module Base
    class BaseObject < GraphQL::Schema::Object
      field :id, Integer, null: false
    end
  end
end
