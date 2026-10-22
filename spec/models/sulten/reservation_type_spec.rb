# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::ReservationType do
  it 'displays the reservation type name' do
    expect(Sulten::ReservationType.new(name: 'Food').to_s).to eq('Food')
  end
end
