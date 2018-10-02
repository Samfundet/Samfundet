module Types
  class BaseObject < GraphQL::Schema::Object
    field :id, Integer, null: false
  end
end
