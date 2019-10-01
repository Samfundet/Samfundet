# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    fornavn 'Fornavn'
    etternavn 'Etternavn'
    sequence(:mail) { |n| "test#{n}@test.com" }
    telefon '123123123'
    passord 'passord'
  end

  trait :with_role do
    transient do
      role_title ''
    end

    after(:create) do |member, evaluator|
      member.roles << create(:role, title: evaluator.role_title)
    end
  end
end
