FactoryGirl.define do
  factory :role do
    name "Name"
    sequence(:title) {|n| "title#{n}"}
    description "Description here"
    passable false
    role_id nil
    trait :passable do
      passable true
    end
  end
end