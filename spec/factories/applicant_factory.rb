# frozen_string_literal: true

FactoryBot.define do
  factory :applicant do
    firstname 'Test'
    surname 'Testesen'
    sequence(:email) { |n| "test#{n}@test.com" }
    sequence(:phone) { |n| "12345678#{n}" }
    password 'password'
    password_confirmation 'password'
    association :campus, factory: :campus
  end
end
