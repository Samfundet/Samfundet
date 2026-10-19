# frozen_string_literal: true

require 'rails_helper'
RSpec.describe BilligEvent do
  let(:event) { BilligEvent.create!(event_name: 'Concert', event_time: 1.day.from_now, sale_to: 1.day.from_now, hidden: false) }
  it 'describes the event with a localized date and title' do
    expect(event.describe).to include('Concert', event.event_time.strftime('%Y'))
  end
  it 'offers only visible events whose sales have not ended' do
    event
    BilligEvent.create!(sale_to: 1.day.ago, hidden: false)
    BilligEvent.create!(sale_to: 1.day.from_now, hidden: true)
    expect(BilligEvent.sale_applicable).to contain_exactly(event)
  end
  it 'finds online ticket groups and nonmember tickets' do
    online = BilligTicketGroup.create!(billig_event: event, num: 10, num_sold: 0, ticket_limit: 3)
    BilligPriceGroup.create!(billig_ticket_group: online, netsale: true, membership_needed: false)
    offline = BilligTicketGroup.create!(billig_event: event, num: 10, num_sold: 0)
    BilligPriceGroup.create!(billig_ticket_group: offline, netsale: false, membership_needed: false)
    expect(event.netsale_billig_ticket_groups).to eq([online])
    expect(event.has_non_member_tickets?).to be(true)
    expect(event.ticket_limit?).to be(true)
    online.billig_price_groups.update_all(membership_needed: true)
    expect(event.has_non_member_tickets?).to be(false)
  end
end
