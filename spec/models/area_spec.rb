# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Area do
  let(:area) { create(:area) }
  it 'requires a name' do
    expect(Area.new).not_to be_valid
    expect(area.to_s).to eq(area.name)
    expect(area.edit_path).to eq(edit_area_path(area))
  end
  it 'builds missing weekdays while retaining persisted hours' do
    hour = StandardHour.create!(area: area, day: 'monday', open: false)
    expect(area.week.map(&:day)).to eq(StandardHour::WEEKDAYS)
    expect(area.week.first).to eq(hour)
    expect(area.by_day('monday')).to eq(hour)
    expect(area.by_day('tuesday')).to be_new_record
  end
  it 'handles an area without opening hours' do
    expect(area.grouped_open_hours).to eq([])
    expect(area.open_now?).to be_nil
    expect(area.open_today?).to be_nil
    expect(area.earliest_open_time).to be_nil
    expect(area.latest_close_time).to be_nil
  end
  it 'groups consecutive weekdays with identical opening hours' do
    StandardHour::WEEKDAYS.each do |day|
      StandardHour.create!(area: area, day: day, open: day != 'sunday', open_time: '16:00', close_time: '22:00')
    end
    groups = area.grouped_open_hours
    expect(groups.size).to eq(2)
    expect(groups.last.last).to eq('Stengt')
    expect(groups.first.last).to include('16:00', '22:00')
  end
  it 'returns current opening times and accounts for closing after midnight' do
    travel_to Time.zone.local(2026, 10, 5, 18) do
      hour = StandardHour.create!(area: area, day: 'monday', open: true, open_time: '16:00', close_time: '22:00')
      expect(area.today).to eq(hour)
      expect(area.open_now?).to be(true)
      expect(area.open_today?).to be(true)
      expect(area.earliest_open_time.strftime('%H:%M')).to eq('16:00')
      expect(area.latest_close_time.strftime('%H:%M')).to eq('22:00')
    end
  end
end
