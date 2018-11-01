# frozen_string_literal: true

module Types
  class EventType < Bases::BaseObject
    field :title, String, null: false
    field :age_limit, AgeLimit, null: false
    field :status, String, null: false
    field :youtube_link, String, null: true
    field :twitter_link, String, null: true
    field :instagram_link, String, null: true
    field :organizer, OrganizerType, null: false
    field :duration, Integer, null: false

    field :short_description, String, null: false do
      argument :language, Language, required: false
    end

    def short_description(language: "NO")
      object["short_description_#{language.downcase}"]
    end

    field :long_description, String, null: false do
      argument :language, Language, required: false
    end

    def long_description(language: "NO")
      object["long_description_#{language.downcase}"]
    end
  end
end
