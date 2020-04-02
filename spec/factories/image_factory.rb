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
include ActionDispatch::TestProcess

FactoryBot.define do
  factory :image do
    title { 'Tittel' }
    image_file do
      fixture_file_upload Rails.root.join('app', 'assets', 'images', 'banner-images', 'kitteh.jpeg')
    end
  end
end
