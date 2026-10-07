# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::Reservation do
  let(:type) { create(:sulten_reservation_type) }
  let(:from) { 2.days.from_now.change(hour: 18) }
  let(:to) { from + 2.hours }
  def table(capacity)
    table = create(:sulten_table, capacity: capacity)
    Sulten::TableReservationType.create!(table: table, reservation_type: type)
    table
  end
  it 'calculates duration and extracts the first name' do
    reservation = build(:sulten_reservation, reservation_from: from, reservation_to: to)
    expect(reservation.reservation_duration).to eq(120)
    expect(reservation.first_name).to eq('Ola')
    reservation.reservation_duration = 60
    expect(reservation.reservation_to).to eq(from + 1.hour)
  end
  it 'provides a missing-table placeholder after a table is removed' do
    reservation = Sulten::Reservation.new
    expect(reservation.missing_table).to be(true)
    expect(reservation.table.capacity).to eq(0)
  end
  it 'rejects unsupported reservation lengths and missing starts' do
    reservation = build(:sulten_reservation, reservation_to: from + 45.minutes, reservation_from: from)
    expect(reservation).not_to be_valid
    expect(reservation.errors[:reservation_duration]).to be_present
    reservation = build(:sulten_reservation, reservation_from: nil, reservation_to: nil)
    expect(reservation).not_to be_valid
    expect(reservation.errors[:reservation_from]).to be_present
  end
  it 'validates future dates and opening hours for public bookings' do
    reservation = build(:sulten_reservation, admin_access: false, reservation_from: 1.day.ago, reservation_to: 1.day.ago + 2.hours)
    expect(reservation).not_to be_valid
    expect(reservation.errors[:reservation_from]).to be_present
    reservation = build(:sulten_reservation, admin_access: false, reservation_from: from.change(hour: 10), reservation_to: from.change(hour: 12))
    expect(reservation).not_to be_valid
  end
  it 'validates email even for administrative bookings' do
    expect(build(:sulten_reservation, email: 'invalid')).not_to be_valid
  end
  it 'detects overly large and empty parties' do
    reservation = build(:sulten_reservation, people: 9)
    reservation.check_amount_of_people
    expect(reservation.errors[:people]).to be_present
    reservation.errors.clear
    reservation.people = 0
    reservation.check_amount_of_people
    expect(reservation.errors[:people]).to be_present
  end
  it 'chooses the smallest available single table' do
    table(8)
    small = table(4)
    table(6)
    expect(Sulten::Reservation.find_tables(from, to, 3, type.id)).to eq([small])
  end
  it 'excludes unavailable tables and unsupported reservation types' do
    table(4).update!(available: false)
    create(:sulten_table, capacity: 4)
    expect(Sulten::Reservation.find_tables(from, to, 3, type.id)).to eq([])
  end
  it 'leaves a thirty-minute cleaning gap around existing reservations' do
    small = table(4)
    create(:sulten_reservation, table: small, reservation_type: type, reservation_from: from - 90.minutes, reservation_to: from - 30.minutes)
    expect(Sulten::Reservation.find_tables(from, to, 3, type.id)).to eq([small])
    expect(Sulten::Reservation.find_tables(from - 1.minute, to, 3, type.id)).to eq([])
  end
  it 'combines neighbouring tables when no single table is large enough' do
    left = table(4)
    right = table(4)
    Sulten::NeighbourTable.create!(table: left, neighbour: right)
    expect(Sulten::Reservation.find_tables(from, to, 6, type.id)).to match_array([left, right])
    expect(Sulten::Reservation.find_tables(from, to, 9, type.id)).to eq([])
  end
  it 'returns the start time only when a table is available' do
    expect(Sulten::Reservation.check_if_time_is_valid(from, to, 3, type.id)).to be_nil
    table(4)
    expect(Sulten::Reservation.check_if_time_is_valid(from, to, 3, type.id)).to eq(from)
  end
  it 'returns half-hour booking slots with earlier weekend cutoffs' do
    allow(Sulten::Reservation).to receive(:check_if_time_is_valid) { |start, *_args| start }
    weekday = Sulten::Reservation.find_available_times('2026-10-05', 2, type.id)
    weekend = Sulten::Reservation.find_available_times('2026-10-10', 2, type.id)
    expect(weekday.length).to eq(11)
    expect(weekend.length).to eq(9)
    expect(weekday.first.strftime('%H:%M')).to eq('16:00')
    expect(weekday.last.strftime('%H:%M')).to eq('21:00')
  end
  it 'detects closure periods and opening-hour boundaries' do
    reservation = build(:sulten_reservation, reservation_from: from, reservation_to: to)
    expect(reservation.in_closed_period?).to be(false)
    create(:sulten_closed_period, closed_from: from - 1.day, closed_to: to)
    expect(reservation.in_closed_period?).to be(true)
    %i[lyche_open? kitchen_open?].each do |method|
      expect(Sulten::Reservation.public_send(method, from.change(hour: 16), to.change(hour: 22))).to be(true)
      expect(Sulten::Reservation.public_send(method, from.change(hour: 15), to.change(hour: 22))).to be(false)
      expect(Sulten::Reservation.public_send(method, from.change(hour: 16), to.change(hour: 23))).to be(false)
    end
  end
end
