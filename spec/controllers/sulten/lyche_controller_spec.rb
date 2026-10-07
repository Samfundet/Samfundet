# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::LycheController, type: :controller do
  it 'shows empty hours when the restaurant area does not exist' do
    get :index
    expect(assigns(:open_hours)).to eq([])
    expect(assigns(:closed)).to be_nil
  end
  it 'shows current closures and restaurant opening hours' do
    area = create(:area, name: 'Lyche')
    StandardHour.create!(area: area, day: 'monday', open: false)
    closure = create(:sulten_closed_period)
    get :index
    expect(assigns(:closed)).to eq(closure)
    expect(assigns(:open_hours)).not_to be_empty
  end
  it 'lists menu categories in configured order' do
    category = create(:sulten_menu_category)
    get :menu
    expect(assigns(:categories)).to contain_exactly(category)
    expect(assigns(:open_hours)).to eq([])
  end
  it 'shows the reservation form before a date is selected' do
    get :reservation
    expect(assigns(:reservation)).to be_new_record
    expect(assigns(:times)).to be_nil
  end
  it 'rejects reservation dates earlier than tomorrow' do
    get :reservation, params: { sulten_reservation: { reservation_from: Date.current.to_s } }
    expect(assigns(:must_be_in_future)).to be(true)
  end
  it 'rejects reservation dates during a closure' do
    create(:sulten_closed_period, closed_from: 1.day.from_now, closed_to: 4.days.from_now)
    get :reservation, params: { sulten_reservation: { reservation_from: 2.days.from_now.to_date.to_s } }
    expect(assigns(:in_closed_period)).to be(true)
  end
  it 'calculates slots for the selected date, guest count and type' do
    area = create(:area, name: 'Lyche')
    StandardHour::WEEKDAYS.each { |day| StandardHour.create!(area: area, day: day, open: true, open_time: '16:00', close_time: '22:00') }
    type = create(:sulten_reservation_type)
    allow(Sulten::Reservation).to receive(:find_available_times).and_return([2.days.from_now.change(hour: 18, min: 0)])
    date = 2.days.from_now.to_date.to_s
    get :reservation, params: { sulten_reservation: { reservation_from: date, reservation_type_id: type.id, reservation_duration: '2' } }
    expect(assigns(:times)).to eq(['18:00'])
    expect(assigns(:number_of_guests)).to eq('2')
    expect(assigns(:reservation_date)).to eq(date)
  end
end
