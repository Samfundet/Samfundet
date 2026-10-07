# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::ClosedPeriod do
  it 'rejects reversed times but allows a one-day closure' do
    expect(build(:sulten_closed_period, closed_to: 5.days.ago)).not_to be_valid
    date = Time.current
    expect(build(:sulten_closed_period, closed_from: date, closed_to: date)).to be_valid
  end
  it 'separates previous, current and future periods' do
    current = create(:sulten_closed_period)
    past = create(:sulten_closed_period, closed_from: 5.days.ago, closed_to: 3.days.ago)
    future = create(:sulten_closed_period, closed_from: 2.days.from_now, closed_to: 3.days.from_now)
    expect(Sulten::ClosedPeriod.current_period).to eq(current)
    expect(Sulten::ClosedPeriod.previous_closed_periods).to contain_exactly(past)
    expect(Sulten::ClosedPeriod.current_and_future_closed_times).to contain_exactly(current, future)
  end
end
