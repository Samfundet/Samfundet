# frozen_string_literal: true

class Mutations::UpdateEvent < Mutations::BaseMutation
  null true
  argument :event_attributes, Types::Inputs::EventAttributes, required: true

  field :event, Types::EventType, null: false
  field :success, Boolean, null: false

  def resolve(event_attributes:)
    event = Event.find_by(id: event_attributes.id)
    puts 'LOOK HERE: attributes'
    # if !event || !event.update(event.column_names, event.column_values)
    puts event_attributes.to_h
    if !event || !event.update(event_attributes.to_h)
      {
        event: nil,
        success: false
      }
    end
    {
      event: event,
      success: true
    }
  end
end
