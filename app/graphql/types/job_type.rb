# frozen_string_literal: true

module Types
  class JobType < Bases::BaseObject
    field :name, String, null: false
  end
end
