# frozen_string_literal: true

module Types
  class MemberType < Bases::BaseObject
    field :forename, String, null: false
    def forename
      object.fornavn
    end

    field :surname, String, null: false
    def surname
      object.etternavn
    end

    field :email, String, null: false
    def email
      object.mail
    end

    field :telephone, String, null: false
    def telephone
      object.telefon
    end
  end
end
