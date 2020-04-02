# frozen_string_literal: true

# == Schema Information
#
# Table name: admissions
#
#  id                             :bigint           not null, primary key
#  title                          :string
#  shown_application_deadline     :datetime
#  user_priority_deadline         :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  shown_from                     :datetime
#  admin_priority_deadline        :datetime
#  actual_application_deadline    :datetime
#  promo_video                    :string           default("https://www.youtube.com/embed/T8MjwROd0dc")
#  groups_with_separate_admission :text
#
FactoryBot.define do
  factory :admission do
    title { 'Opptak' }
    shown_from { 1.week.ago }
    shown_application_deadline { 1.week.from_now }
    actual_application_deadline { 1.week.from_now + 2.hours }
    user_priority_deadline { 8.days.from_now }
    admin_priority_deadline { 9.days.from_now }

    trait :past do
      shown_from { 1.week.ago }
      shown_application_deadline { 3.days.ago }
      actual_application_deadline { 3.days.ago + 2.hours }
      user_priority_deadline { 2.days.ago }
      admin_priority_deadline { 1.day.ago }
    end

    trait :future do
      shown_from { 1.day.from_now }
      shown_application_deadline { 3.days.from_now }
      actual_application_deadline { 3.days.from_now + 2.hours }
      user_priority_deadline { 4.days.from_now }
      admin_priority_deadline { 5.days.from_now }
    end

    factory :admission_with_jobs do
      after(:create) do |admission|
        create_list(:job, 5, admission: admission)
      end
    end
  end
end
