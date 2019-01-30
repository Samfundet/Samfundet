# frozen_string_literal: true

include ActionDispatch::TestProcess

FactoryBot.define do
  factory :image do
    title 'Tittel'
    image_file do
      fixture_file_upload Rails.root.join('app', 'assets', 'images', 'banner-images', 'kitteh.jpeg')
    end
  end
end
