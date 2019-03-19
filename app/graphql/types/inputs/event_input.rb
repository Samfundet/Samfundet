# frozen_string_literal: true

module Types
  module Inputs
    class EventInput < Types::Bases::BaseInputObject
      argument :type, Types::EventType, required: true, as: :event_type

      argument :title_no, String, required: true, as: :non_billig_title_no
      argument :title_en, String, required: true
      argument :short_description_no, String, required: true
      argument :short_description_en, String, required: true
<<<<<<< HEAD
      argument :long_description_no, String, required: true
      argument :long_description_en, String, required: true
=======
      argument :long_description_no, Types::Text, required: true
      argument :long_description_en, Types::Text, required: true
>>>>>>> c1b3ee52b9282d57a3d2ca3ae104593a4232592b

      argument :price_type, Types::PriceType, required: true
      argument :price_groups, [PriceGroupInput], required: false

      argument :area, Types::Area, required: true
      argument :age_limit, AgeLimit, required: true
      argument :status, Types::EventStatus, required: true
      # argument :organizer, Types::OrganizerType, required: true

      argument :start_time, GraphQL::Types::ISO8601DateTime, required: true, as: :non_billig_start_time
      argument :duration, Integer, required: true

      argument :youtube_link, String, required: false
      argument :twitter_link, String, required: false
      argument :instagram_link, String, required: false
      argument :soundcloud_link, String, required: false
    end
  end
end
