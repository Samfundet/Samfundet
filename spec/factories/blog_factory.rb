# frozen_string_literal: true

# == Schema Information
#
# Table name: blogs
#
#  id                :bigint           not null, primary key
#  title_no          :string
#  content_no        :text
#  author_id         :integer
#  published         :boolean
#  publish_at        :datetime
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  image_id          :integer
#  lead_paragraph_no :text
#  title_en          :string
#  lead_paragraph_en :text
#  content_en        :text
#
FactoryBot.define do
  factory :blog do
    title_no { 'Test' }
    title_en { 'Test' }
    lead_paragraph_no { 'Test' }
    lead_paragraph_en { 'Test' }
    content_no { 'Test' }
    content_en { 'Test' }
    publish_at { Time.current }
    author_id { 'Test' }
    image_id { 'Test' }
  end
end
