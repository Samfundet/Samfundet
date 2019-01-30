# frozen_string_literal: true

FactoryBot.define do
  factory :member do
    fornavn 'Fornavn'
    etternavn 'Etternavn'
    sequence(:mail) { |n| "test#{n}@test.com" }
    telefon '123123123'
    transient do
      roles { [] }
    end

    after(:create) do |member, evaluator|
      member.update_attributes!(roles: evaluator.roles)
    end
  end
end
