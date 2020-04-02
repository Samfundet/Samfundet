# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id                :bigint           not null, primary key
#  name              :string
#  title             :string
#  description       :text
#  show_in_hierarchy :boolean          default(FALSE)
#  role_id           :integer
#  group_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  passable          :boolean          default(FALSE)
#
FactoryBot.define do
  factory :role do
    name { 'Name' }
    sequence(:title) { |n| "title#{n}" }
    description { 'Description here' }
    passable { false }
    role_id { nil }
    trait :passable do
      passable { true }
    end
  end
end
