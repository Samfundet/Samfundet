module Types
  class GroupType < BaseObject
    field :name, String, null: false
    field :abbreviation, String, null: true
    field :website, String, null: false
    field :short_description, String, null: false
    field :long_description, String, null: false
    field :page, PageType, null: true
  end
end
