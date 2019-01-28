# frozen_string_literal: true

class SocialMedia < GraphQL::Schema::Object
  field :youtube_link, String, null: true
  field :twitter_link, String, null: true
  field :instagram_link, String, null: true
  field :soundcloud_link, String, null: true
  field :facebook_link, String, null: true
end

module Types
  class Event < Bases::RailsResource
    field :title, String, null: false do
      description "The events title"
      argument :language, Language, required: false, default_value: 'NO'
    end
    def title(language:)
      object.public_send("title_#{language.downcase}")
    end

    field :start_time, GraphQL::Types::ISO8601DateTime, "The events start time", null: false

    field :area, Area, "The area where the event takes place", null: false

    field :type, EventType, "The type of the event", null: false
    def type
      object.event_type
    end

    field :social_media, SocialMedia, "An objet containing links to the event in social media", null: false
    def social_media
      object
    end

    field :price_type, PriceType, "The type of ticket pricing for the event", null: false
    field :price_groups, [PriceGroupType], "The ticket price groups of the event", null: true
    def price_groups
      object.price
    end

    field :age_limit, AgeLimit, "The age restriction of the event", null: false
    field :status, EventStatus, "The status of the event", null: false
    field :organizer, OrganizerType, "The organizer of the event", null: false
    field :duration, Integer, "The duration of the event in minutes", null: false

    field :short_description, String, "A short description of the event", null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end

    def short_description(language:)
      object["short_description_#{language.downcase}"]
    end

    field :long_description, String, "A long description of the event", null: false do
      argument :language, Language, required: false, default_value: 'NO'
    end

    def long_description(language:)
      object["long_description_#{language.downcase}"]
    end
  end
end
