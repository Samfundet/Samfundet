# frozen_string_literal: true
FactoryGirl.define do
  factory :job_application do
    motivation 'Motivation for applying for this position'
    applicant
    job
  end
end
