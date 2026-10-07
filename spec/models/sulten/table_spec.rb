# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::Table do
  it 'requires a unique table number and a capacity' do
    table = create(:sulten_table)
    expect(build(:sulten_table, number: table.number)).not_to be_valid
    expect(build(:sulten_table, capacity: nil)).not_to be_valid
    expect(table.to_s).to eq(table.number)
  end
  it 'finds neighbours in both directions without including itself' do
    left = create(:sulten_table)
    middle = create(:sulten_table)
    right = create(:sulten_table)
    Sulten::NeighbourTable.create!(table: left, neighbour: middle)
    Sulten::NeighbourTable.create!(table: middle, neighbour: right)
    expect(middle.neighbours).to contain_exactly(left, right)
    expect(middle.neighbour_count).to eq(2)
    expect(middle.is_neighbour?(left.id)).to be(true)
    expect(middle.is_neighbour?(middle.id)).to be(false)
    expect(middle.neighbour_string.split(', ').map(&:to_i)).to contain_exactly(left.number, right.number)
    expect(left.neighbour_groups).to include([left, middle], [left, middle, right])
  end
  it 'handles isolated tables and enforces the recursion limit' do
    table = create(:sulten_table)
    expect(table.neighbour_string).to eq('-')
    expect(table.neighbour_groups).to eq([])
    expect(table.neighbour_groups(5)).to be_nil
  end
  it 'finds tables supporting exactly the requested number of reservation types' do
    table = create(:sulten_table)
    type = create(:sulten_reservation_type)
    Sulten::TableReservationType.create!(table: table, reservation_type: type)
    expect(Sulten::Table.tables_with_i_reservation_types(1)).to contain_exactly(table)
    expect(Sulten::Table.tables_with_i_reservation_types(0)).to be_empty
  end
end
