# frozen_string_literal: true

class Mutations::UpdateEvent < Mutations::BaseMutation
  argument :event, Types::Inputs::EventAttributes, required: true

  field :event, Types::EventType, null: true
  field :success, Boolean, null: false

  def resolve(event:)
    e = Event.find_by(id: event.id)
    if e
      if e.update(event.to_h)
        {
          event: e,
          success: true
        }
      else
        {
          event: nil,
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
