# frozen_string_literal: true

FactoryBot.define do
  factory :blog do
    title_no 'Test'
    title_en 'Test'
    lead_paragraph_no 'Test'
    lead_paragraph_en 'Test'
    content_no 'Test'
    content_en 'Test'
    publish_at Time.current
    author_id 'Test'
    image_id 'Test'
  end
end
