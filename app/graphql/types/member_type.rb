# frozen_string_literal: true

module Types
  class MemberType < GraphQL::Schema::Object
    field :forename, String, null: false
    def forename
      object.fornavn
    end

    field :surname, String, null: false
    def surname
      object.etternavn
    end
  end
end
