# frozen_string_literal: true

module Mutations
  class MutationType < Types::Bases::BaseObject
    field :update_event, mutation: Mutations::UpdateEvent
  end
end
