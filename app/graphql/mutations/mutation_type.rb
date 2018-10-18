# frozen_string_literal: true

module Mutations
  class MutationType < Types::Base::BaseObject
    field :update_event, mutation: Mutations::UpdateEvent
  end
end
