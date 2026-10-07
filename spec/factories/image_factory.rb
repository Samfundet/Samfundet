# frozen_string_literal: true

# == Schema Information
#
# Table name: images
#
#  id                      :bigint           not null, primary key
#  title                   :string
#  uploader_id             :integer
#  image_file_file_name    :string
#  image_file_content_type :string
#  image_file_file_size    :integer
#  image_file_updated_at   :datetime
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
FactoryBot.define do
  factory :image do
    sequence(:title) { |n| "Tittel #{n}" }
    image_file do
      Rack::Test::UploadedFile.new(
        Rails.root.join('app/assets/images/banner-images/kitteh.jpeg').to_s,
        'image/jpeg'
      )
    end
  end
end
