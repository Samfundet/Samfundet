# frozen_string_literal: true

module Types
  class MemberType < GraphQL::Schema::Object
    field :fornavn, String, null: false
    field :etternavn, String, null: false
  end
end
