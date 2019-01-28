# frozen_string_literal: true

module Types
  class GroupType < Bases::RailsResource
    field :name, String, null: false
    field :abbreviation, String, null: true
    field :website, String, null: true
    field :short_description, String, null: true
    field :long_description, String, null: true
    field :page, PageType, null: true
  end
end
