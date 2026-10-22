# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StandardHoursHelper, type: :helper do
  it 'includes locale, record count and operating day in the cache key' do
    travel_to Time.zone.local(2026, 10, 5, 18) do
      expect(helper.cache_key_for_standard_hours).to include('en-standard-hours/all-0-', (Time.current - 4.hours).to_s)
      StandardHour.create!(area: create(:area), day: 'monday', open: false)
      expect(helper.cache_key_for_standard_hours).to include('all-1-')
    end
  end
  it 'changes the cache key when a closure starts' do
    before = helper.cache_key_for_standard_hours
    create(:everything_closed_period)
    expect(helper.cache_key_for_standard_hours).not_to eq(before)
  end
end
