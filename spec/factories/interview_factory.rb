# frozen_string_literal: true

# == Schema Information
#
# Table name: interviews
#
#  id                 :bigint           not null, primary key
#  time               :datetime
#  acceptance_status  :string(10)
#  job_application_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  location           :string
#  comment            :text
#
FactoryBot.define do
  factory :interview do
    time { rand(1..10).days.from_now }
    acceptance_status
    job_application
    location { 'Location' }
    comment { 'Comment' }
  end
end
