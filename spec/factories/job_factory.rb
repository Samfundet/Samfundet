# frozen_string_literal: true

FactoryBot.define do
  factory :job do
    title_no 'Title NO'
    title_en 'Title EN'
    teaser_no 'Job teaser_no'
    teaser_en 'Job teaser_en'
    description_no 'Beskrivelse'
    description_en 'Description'
    is_officer false
    default_motivation_text_no 'Standard motivasjonsteks'
    default_motivation_text_en 'Default motivation text'
    group
    admission
    trait :officer do
      is_officer true
    end
  end
end
