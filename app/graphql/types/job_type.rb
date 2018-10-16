# frozen_string_literal: true

module Types
  class JobType < Base::BaseObject
    field :name, String, null: false
  end
end
