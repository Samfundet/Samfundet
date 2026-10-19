# frozen_string_literal: true

require 'rails_helper'

FactoryBot.define do
  factory :area do
    sequence(:name) { |n| "Area #{n}" }
  end
  factory :page do
    sequence(:name_no) { |n| "side-#{n}" }
    sequence(:name_en) { |n| "page-#{n}" }
    role
    title_no { 'Tittel' }
    title_en { 'Title' }
    content_no { 'Innhold' }
    content_en { 'Content' }
  end
  factory :everything_closed_period do
    message_no { 'Stengt' }
    message_en { 'Closed' }
    event_message_no { 'Stengt' }
    event_message_en { 'Closed' }
    closed_from { 1.day.ago }
    closed_to { 1.day.from_now }
  end
  factory :sulten_closed_period, class: 'Sulten::ClosedPeriod' do
    message_no { 'Stengt' }
    message_en { 'Closed' }
    closed_from { 1.day.ago }
    closed_to { 1.day.from_now }
  end
  factory :sulten_menu_category, class: 'Sulten::MenuCategory' do
    title_no { 'Mat' }
    title_en { 'Food' }
    order { 1 }
  end
  factory :sulten_menu_item, class: 'Sulten::MenuItem' do
    title_no { 'Suppe' }
    title_en { 'Soup' }
    description_no { 'God suppe' }
    description_en { 'Good soup' }
    allergens_no { 'Melk' }
    allergens_en { 'Milk' }
    price { 100 }
    price_member { 80 }
    association :sulten_menu_category, factory: :sulten_menu_category
  end
  factory :sulten_table, class: 'Sulten::Table' do
    sequence(:number)
    capacity { 4 }
    available { true }
  end
  factory :sulten_reservation_type, class: 'Sulten::ReservationType' do
    name { 'Mat' }
  end
  factory :sulten_reservation, class: 'Sulten::Reservation' do
    reservation_from { 2.days.from_now.change(hour: 18) }
    reservation_to { reservation_from + 2.hours }
    people { 2 }
    name { 'Ola Nordmann' }
    telephone { '12345678' }
    email { 'ola@example.com' }
    association :table, factory: :sulten_table
    association :reservation_type, factory: :sulten_reservation_type
    admin_access { true }
  end
end
