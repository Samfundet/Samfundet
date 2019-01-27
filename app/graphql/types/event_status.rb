# frozen_string_literal: true

module Types
  class EventStatus < Bases::BaseEnum
  end
end

Event::STATUS.each do |event_status|
  Types::EventStatus.value(event_status.upcase, event_status, value: event_status)
end
