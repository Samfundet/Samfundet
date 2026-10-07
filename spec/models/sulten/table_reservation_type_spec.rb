# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Sulten::TableReservationType do
  it 'connects supported reservation types to tables in both directions' do
    table = create(:sulten_table)
    type = create(:sulten_reservation_type)
    Sulten::TableReservationType.create!(table: table, reservation_type: type)
    expect(table.reservation_types).to contain_exactly(type)
    expect(type.tables).to contain_exactly(table)
  end
end
