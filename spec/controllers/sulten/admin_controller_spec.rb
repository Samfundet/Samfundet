# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::AdminController, type: :controller do
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'shows an empty calendar for the current day' do
    get :index
    expect(assigns(:calendar_date)).to eq(Date.current)
    expect(assigns(:is_today)).to be(true)
    expect(assigns(:render_reservations)).to eq({})
  end
  it 'places reservations on the daily timeline and totals guests' do
    date = 2.days.from_now.to_date
    reservation = create(:sulten_reservation, reservation_from: date.in_time_zone + 18.hours, reservation_to: date.in_time_zone + 20.hours, people: 3)
    get :index, params: { date: date.strftime('%d-%m-%Y') }
    expect(assigns(:is_today)).to be(false)
    expect(assigns(:total_reservations)).to eq(1)
    expect(assigns(:total_people)).to eq(3)
    rendered = assigns(:render_reservations)[reservation.table_id].first
    expect(rendered.first).to eq(reservation)
    expect(rendered[1]).to be_between(0, 100)
    expect(rendered[2]).to be > 0
  end
end
