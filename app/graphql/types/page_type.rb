# frozen_string_literal: true

module Types
  class PageType < Bases::BaseObject
    field :name_no, String, null: false
    field :name_en, String, null: false
  end
end
