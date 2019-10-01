# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |n| "Group#{n}" }
    abbreviation { 'gn' }
    website { 'http://google.com' }
    short_description { 'Short description' }
    long_description { 'Long description' }
    group_type
  end

  factory :group_type do
    sequence(:description) { |n| "beskrivelse#{n}" }
  end
end
