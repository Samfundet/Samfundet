# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::NeighbourTable do
  it 'describes the relationship by the two table IDs' do
    expect(Sulten::NeighbourTable.new(table_id: 2, neighbour_id: 3).to_s).to eq('2:3')
  end
end
