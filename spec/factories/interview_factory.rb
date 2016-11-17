# frozen_string_literal: true
FactoryGirl.define do
  factory :interview do
    time { rand(1..10).days.from_now }
    acceptance_status
    job_application
    location 'Location'
    comment 'Comment'
  end
end
