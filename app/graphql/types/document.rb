# frozen_string_literal: true

module Types
  class Document < Bases::BaseObject
    field :title, String, null: false

    field :uploader, MemberType, null: false

    field :publication_date, GraphQL::Types::ISO8601DateTime, null: false

    field :file, String, null: false

    field :category, DocumentCategory, null: false
  end
end
