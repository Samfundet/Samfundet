# frozen_string_literal: true

# == Schema Information
#
# Table name: campus
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE)
#
FactoryBot.define do
  factory :campus do
    name { 'Gloeshaugen' }
    active { true }
  end
end
