# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    title_en { Faker::Lorem.sentence }
    non_billig_title_no { Faker::Lorem.sentence }
    short_description_en { Faker::Lorem.sentences }
    short_description_no { Faker::Lorem.sentences }
    event_type { :music }
    age_limit { :eighteen }
    area { Area.create(name: 'NBB', description: 'Best place on Earth') }
    price_type { 'free' }
    status { :active }
    primary_color { '#fff' }
    secondary_color { '#fff' }
    banner_alignment { 'hide' }
    non_billig_start_time { 2.days.from_now }
    publication_time { Time.now }
    organizer { ExternalOrganizer.create!(name: 'NTNU') }
    image { Image.default_image }
  end
end
