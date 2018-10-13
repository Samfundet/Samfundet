# frozen_string_literal: true

module Mutation
  class MutationType < Types::BaseObject
    field :update_event, mutation: Mutations::UpdateEvent
  end
end
