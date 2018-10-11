# frozen_string_literal: true

module Types
  class EventType < BaseObject
    field :title, String, null: false
    field :age_limit, AgeLimit, null: false
    field :status, String, null: false
    field :youtube_link, String, null: true
    field :twitter_link, String, null: true
    field :instagram_link, String, null: true
    field :organizer, GroupType, null: false
    field :duration, Integer, null: false
  end
end
