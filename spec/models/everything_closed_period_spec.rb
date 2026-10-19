# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EverythingClosedPeriod do
  let(:attributes) { { message_no: 'Stengt', message_en: 'Closed', event_message_no: 'Stengt', event_message_en: 'Closed', closed_from: 1.day.ago, closed_to: 1.day.from_now } }

  it 'rejects reversed or equal dates' do
    [0, -1].each do |offset|
      period = described_class.new(attributes.merge(closed_to: attributes[:closed_from] + offset.days))
      expect(period).not_to be_valid
      expect(period.errors[:closed_to]).to be_present
    end
  end

  it 'selects current and future periods without including expired closures' do
    current = described_class.create!(attributes)
    future = described_class.create!(attributes.merge(closed_from: 2.days.from_now, closed_to: 3.days.from_now))
    described_class.create!(attributes.merge(closed_from: 5.days.ago, closed_to: 3.days.ago))
    expect(described_class.current_period).to eq(current)
    expect(described_class.current_and_future_closed_times).to contain_exactly(current, future)
    expect(described_class.active_closed_periods).to contain_exactly(current)
  end
end
