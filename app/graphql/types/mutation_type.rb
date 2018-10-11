# frozen_string_literal: true

class Types::MutationType < Types::BaseObject
  field :update_event, mutation: Mutations::UpdateEvent
end
