# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StandardHour do
  let(:area) { Area.create!(name: 'Cafe') }
  let(:hour) { described_class.new(area: area, day: 'monday', open: true, open_time: '16:00', close_time: '22:00') }

  it 'requires opening times only for open days' do
    hour.open_time = hour.close_time = nil
    expect(hour).not_to be_valid
    hour.open = false
    expect(hour).to be_valid
  end

  it 'rejects unknown weekdays' do
    hour.day = 'holiday'
    expect(hour).not_to be_valid
  end

  it 'allows one record per area and weekday' do
    hour.save!
    expect(hour.dup).not_to be_valid
    copy = hour.dup
    copy.area = Area.create!(name: 'Other cafe')
    expect(copy).to be_valid
  end

  it 'moves closing time to the next day when open past midnight' do
    hour.close_time = '02:00'
    expect(hour.adjusted_close_time).to eq(hour.close_time + 1.day)
    hour.close_time = '22:00'
    expect(hour.adjusted_close_time).to eq(hour.close_time)
  end

  it 'uses the previous weekday until 04:00' do
    hour.save!
    travel_to Time.zone.local(2026, 10, 6, 3, 59) do
      expect(StandardHour.today).to contain_exactly(hour)
      expect(StandardHour.open_today).to contain_exactly(hour)
    end
    travel_to Time.zone.local(2026, 10, 6, 4) { expect(StandardHour.today).to be_empty }
  end

  it 'reports open only within the opening interval' do
    travel_to Time.zone.local(2026, 10, 5, 18) { expect(hour.open_now?).to be(true) }
    travel_to Time.zone.local(2026, 10, 5, 15) { expect(hour.open_now?).to be(false) }
    hour.open = false
    travel_to Time.zone.local(2026, 10, 5, 18) { expect(hour.open_now?).to be(false) }
  end
end
