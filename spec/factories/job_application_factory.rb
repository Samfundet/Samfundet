# frozen_string_literal: true

# == Schema Information
#
# Table name: job_applications
#
#  id           :bigint           not null, primary key
#  motivation   :text
#  priority     :integer
#  applicant_id :integer
#  job_id       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  withdrawn    :boolean          default(FALSE)
#
FactoryBot.define do
  factory :job_application do
    motivation { 'Motivation for applying for this position' }
    applicant
    job
  end
end
