# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PriceGroup do
  it 'requires a name and an integer price' do
    expect(PriceGroup.new(name: 'Member', price: 0)).to be_valid
    expect(PriceGroup.new(name: '', price: 100)).not_to be_valid
    expect(PriceGroup.new(name: 'Member', price: nil)).not_to be_valid
    expect(PriceGroup.new(name: 'Member', price: 'one hundred')).not_to be_valid
  end
end
