# frozen_string_literal: true

class Mutations::UpdateEvent < GraphQL::Schema::Mutation
  null true

  argument :id, ID, required: true, description: 'ID of an event.'
  argument :event_input, Types::Inputs::EventInput, required: true

  field :event, Types::Event, null: true
  field :success, Boolean, null: false
  field :errors, Types::JsonType, null: true

  def resolve(id:, event_input:)
    e = Event.find_by(id: id)
    if e
      if e.update(event_input.to_h)
        {
          event: e,
          success: true
        }
      else
        {
          event: nil,
          errors: e.errors.to_hash,
          success: false
        }
      end
    else
      {
        event: nil,
        success: false
      }
    end
  end
end
