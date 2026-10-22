# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BilligPaymentErrorPriceGroup do
  it 'resolves the corresponding Samfundet event through Billig' do
    event = create(:event)
    billig = BilligEvent.create!(event_name: 'Concert')
    event.update_columns(billig_event_id: billig.id)
    group = BilligTicketGroup.create!(billig_event: billig)
    price = BilligPriceGroup.create!(billig_ticket_group: group)
    error = BilligPaymentErrorPriceGroup.new(billig_price_group: price)
    expect(error.samfundet_event).to eq(event)
  end
end
