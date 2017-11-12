# frozen_string_literal: true

FactoryGirl.define do
  factory :member do
    fornavn 'Fornavn'
    etternavn 'Etternavn'
    sequence(:mail) { |n| 'test#{n}@test.com' }
    telefon '123123123'
    passord 'passord'
  end
end
