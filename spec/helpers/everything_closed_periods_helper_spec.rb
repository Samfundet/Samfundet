# frozen_string_literal: true

require 'rails_helper'
RSpec.describe EverythingClosedPeriodsHelper, type: :helper do
  it 'returns the current closure or nil when there is none' do
    expect(helper.samfundet_closed?).to be_nil
    period = instance_double(EverythingClosedPeriod)
    allow(EverythingClosedPeriod).to receive(:current_period).and_return(period)
    expect(helper.samfundet_closed?).to eq(period)
  end
end
