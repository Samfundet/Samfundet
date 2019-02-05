# frozen_string_literal: true

module Types
  class Role < Bases::BaseObject
    field :name, String, null: false
    field :description0, String, null: false
    field :title, String, null: false
    field :group, Types::GroupType, null: false
    field :passable, Boolean, null: false

    field :parent, Role, null: true
    def parent
      object.role
    end

    field :children, [Role], null: true
    def children
      object.roles
    end
  end
end
