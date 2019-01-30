# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    name 'Member'
    title { name.downcase }
    description 'A role'

    members { [] }
  end
end
