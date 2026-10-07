# frozen_string_literal: true

FactoryBot.define do
  factory :info_box do
    title_no { 'Velkommen' }
    title_en { 'Welcome' }
    body_no { 'Les mer' }
    body_en { 'Read more' }
    color { 'blue' }
    start_time { Time.current }
    end_time { 1.day.from_now }
    position { 1 }
    image
  end
end
