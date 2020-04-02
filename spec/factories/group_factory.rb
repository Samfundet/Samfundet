# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                :bigint           not null, primary key
#  name              :string
#  abbreviation      :string
#  website           :string
#  group_type_id     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  short_description :text
#  long_description  :text
#  page_id           :integer
#
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
