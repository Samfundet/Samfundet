module Types
  class QueryType < Types::BaseObject
    field :events, [EventType], null: false do
      description "Get events."
    end

    def events
      Event.all
    end
  end
end
