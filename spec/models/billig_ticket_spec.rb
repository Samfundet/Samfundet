# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BilligTicket do
  it 'resolves the event through the price group and ticket group' do
    event = BilligEvent.create!(event_name: 'Concert')
    group = BilligTicketGroup.create!(billig_event: event)
    price = BilligPriceGroup.create!(billig_ticket_group: group)
    ticket = BilligTicket.new(billig_price_group: price)
    expect(ticket.billig_event).to eq(event)
  end
end
