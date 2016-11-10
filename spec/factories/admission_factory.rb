FactoryGirl.define do
  factory :admission do
    title "Opptak"
    shown_from 1.week.ago
    shown_application_deadline 1.week.from_now
    actual_application_deadline 1.week.from_now + 2.hours
    user_priority_deadline 8.days.from_now
    admin_priority_deadline 9.days.from_now

    trait :past do
      shown_from 1.week.ago
      shown_application_deadline 3.days.ago
      actual_application_deadline 3.days.ago + 2.hours
      user_priority_deadline 2.days.ago
      admin_priority_deadline 1.day.ago
    end

    trait :future do
      shown_from 1.day.from_now
      shown_application_deadline 3.days.from_now
      actual_application_deadline 3.days.from_now + 2.hours
      user_priority_deadline 4.days.from_now
      admin_priority_deadline 5.days.from_now
    end

    factory :admission_with_jobs do
      after(:create) do |admission|
        create_list(:job, 5, admission: admission)
      end
    end
  end
end
