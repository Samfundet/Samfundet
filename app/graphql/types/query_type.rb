# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :events, [EventType], null: false do
      description "Get events."
    end

    def events
      Event.all
    end

    field :event, EventType, null: true do
      argument :id, Integer, required: true
      description "Get a single event."
    end

    def event(id:)
      Event.find_by(id: id)
    end

    field :groups, [GroupType], null: false do
      description "Get all groups."
    end
    def groups
      Group.all
    end
  end
end
