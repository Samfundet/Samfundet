# frozen_string_literal: true

module Types
  module Inputs
    class EventInput < Types::Bases::BaseInputObject
      argument :title_no, String, required: true, as: :non_billig_title_no
      argument :title_en, String, required: true

      argument :short_description_no, String, required: true
      argument :short_description_en, String, required: true

      argument :long_description_no, String, required: true
      argument :long_description_en, String, required: true

      argument :start_time, GraphQL::Types::ISO8601DateTime, required: true, as: :non_billig_start_time
      argument :duration, Integer, required: true

      argument :area, Types::Area, required: true
      argument :age_limit, Types::AgeLimit, required: true
      argument :status, String, required: true
      argument :youtube_link, String, required: false
      argument :twitter_link, String, required: false
      argument :instagram_link, String, required: false
      argument :soundcloud_link, String, required: false
      #argument :organizer, Types::OrganizerType, required: true
      argument :duration, Integer, required: true


      argument :age_limit, AgeLimit, required: true
      argument :youtube_link, String, required: true
    end
  end
end
