# frozen_string_literal: true

# == Schema Information
#
# Table name: applicants
#
#  id                         :bigint           not null, primary key
#  firstname                  :string
#  surname                    :string
#  email                      :string
#  hashed_password            :string
#  phone                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  interested_other_positions :boolean
#  disabled                   :boolean          default(FALSE)
#  campus_id                  :integer
#
FactoryBot.define do
  factory :applicant do
    firstname { 'Test' }
    surname { 'Testesen' }
    sequence(:email) { |n| "test#{n}@test.com" }
    sequence(:phone) { |n| "12345678#{n}" }
    password { 'password' }
    password_confirmation { 'password' }
    association :campus, factory: :campus
  end

  trait :with_job_applications do
    after(:create) do |applicant|
      create_list(:job_application, 1, applicant: applicant)
    end
  end
end
