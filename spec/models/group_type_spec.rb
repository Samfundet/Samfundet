# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupType do
  it 'requires description and priority' do
    %i[description priority].each do |field|
      type = build(:group_type, field => nil)
      expect(type).not_to be_valid
      expect(type.errors[field]).to be_present
    end
  end

  it 'rejects duplicate descriptions' do
    type = create(:group_type)
    expect(build(:group_type, description: type.description)).not_to be_valid
  end

  it 'sorts by priority and displays its description' do
    low = create(:group_type, priority: 1)
    high = create(:group_type, priority: 10)
    expect(GroupType.all).to eq([high, low])
    expect(low <=> high).to eq(-1)
    expect(high.to_s).to eq(high.description)
  end
end
