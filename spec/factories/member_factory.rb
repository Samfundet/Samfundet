# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  medlem_id :bigint           not null, primary key
#  fornavn   :string
#  etternavn :string
#  mail      :string
#  telefon   :string
#  passord   :string
#
FactoryBot.define do
  factory :member do
    fornavn { 'Fornavn' }
    etternavn { 'Etternavn' }
    sequence(:mail) { |n| "test#{n}@test.com" }
    telefon { '123123123' }
    passord { 'passord' }
  end

  trait :with_role do
    transient do
      role_title { '' }
    end

    after(:create) do |member, evaluator|
      member.roles << create(:role, title: evaluator.role_title)
    end
  end
end
