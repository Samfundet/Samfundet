# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BilligPriceGroup do
  it 'links ticket prices and payment errors to the correct ticket group' do
    group = BilligTicketGroup.create!(num: 10, num_sold: 0)
    price = BilligPriceGroup.create!(billig_ticket_group: group, price: 100)
    error = BilligPaymentErrorPriceGroup.create!(billig_price_group: price, error: 'session', number_of_tickets: 2)
    expect(price.billig_ticket_group).to eq(group)
    expect(price.billig_payment_error_price_groups.pluck(:error, :number_of_tickets)).to eq([[error.error, 2]])
  end
end
