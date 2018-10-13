# frozen_string_literal: true

module Types
  class EventAttributes < BaseInputObject
    argument :non_billig_title_no, String, required: true
    argument :title_en, String, required: true
    argument :age_limit, AgeLimit, required: true
    argument :youtube_link, String, required: true
  end
end
