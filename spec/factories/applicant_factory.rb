FactoryGirl.define do
  factory :applicant do
    firstname 'Test'
    surname 'Testesen'
    sequence(:email) {|n| "test#{n}@test.com"}
    phone '123456789'
    password 'password'
    password_confirmation 'password'
    campus 'Gløs'
  end
end