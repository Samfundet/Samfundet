# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :update_event, mutation: Mutations::UpdateEvent
  end
end
