# frozen_string_literal: true

module Types
  class EventType < Bases::BaseObject
    field :title, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end

    def title(language:)
      object.public_send("title_#{language.downcase}")
    end

    field :start_time, GraphQL::Types::ISO8601DateTime, null: false
    field :end_time, GraphQL::Types::ISO8601DateTime, null: false

    field :area, Area, null: false

    field :updated_at, GraphQL::Types::ISO8601DateTime, null: false
    field :age_limit, AgeLimit, null: false
    field :status, String, null: false
    field :youtube_link, String, null: true
    field :twitter_link, String, null: true
    field :instagram_link, String, null: true
    field :soundcloud_link, String, null: true
    field :organizer, OrganizerType, null: false
    field :duration, Integer, null: false

    field :short_description, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end

    def short_description(language:)
      object["short_description_#{language.downcase}"]
    end

    field :long_description, String, null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end

    def long_description(language:)
      object["long_description_#{language.downcase}"]
    end
  end
end
