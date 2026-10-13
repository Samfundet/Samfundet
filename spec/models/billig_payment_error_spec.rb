# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BilligPaymentError do
  it 'retrieves errors by payment session without mixing messages' do
    first = BilligPaymentError.create!(error: 'first', message: 'Invalid card')
    BilligPaymentError.create!(error: 'second', message: 'Unavailable')
    expect(BilligPaymentError.find_by(error: 'first').message).to eq(first.message)
    expect(BilligPaymentError.find_by(error: 'unknown')).to be_nil
  end
end
