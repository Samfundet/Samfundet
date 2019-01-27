# frozen_string_literal: true

module Types
  class EventType < Bases::BaseEnum
    graphql_name 'EventType'
  end
end

Event::EVENT_TYPE.each do |type|
  Types::EventType.value(type.upcase, type, value: type)
end
