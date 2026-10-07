# frozen_string_literal: true

require 'rails_helper'
require 'table_print'
require Rails.root.join('lib/billig_service')
RSpec.describe BilligService do
  let(:price) do
    event = BilligEvent.create!(event_name: 'Concert')
    group = BilligTicketGroup.create!(billig_event: event, num: 100, num_sold: 0)
    BilligPriceGroup.create!(billig_ticket_group: group, price: 100, price_group_name: 'Member')
  end
  def pay(attributes = {})
    params = { "price_#{price.id}_count" => '2', email: 'buyer@example.com' }.merge(attributes)
    response = nil
    expect { response = Rack::MockRequest.new(BilligService).post('/pay', params: params) }.to output.to_stdout
    response
  end
  it 'creates tickets and redirects to the success callback when accepted' do
    allow($stdin).to receive(:gets).and_return('y')
    expect { @response = pay }.to change(BilligTicket, :count).by(2)
    expect(@response.status).to eq(302)
    expect(@response['Location']).to include('/events/purchase_callback/')
    expect(BilligPurchase.last.owner_email).to eq('buyer@example.com')
  end
  it 'records database failures without creating tickets' do
    allow($stdin).to receive(:gets).and_return('n', '1')
    expect { @response = pay }.to change(BilligPaymentError, :count).by(1)
    expect(@response['Location']).to include('bsession=')
    expect(BilligTicket.count).to eq(0)
  end
  it 'records field failures with previous ticket quantities' do
    allow($stdin).to receive(:gets).and_return('n', '2')
    expect { pay(cardnumber: '123') }.to change(BilligPaymentErrorPriceGroup, :count).by(1)
    expect(BilligPaymentErrorPriceGroup.order(created_at: :desc).first.number_of_tickets).to eq(2)
    expect(BilligPaymentError.order(created_at: :desc).first.owner_cardno).to eq(123)
  end
  it 'can reject without a recorded error' do
    allow($stdin).to receive(:gets).and_return('n', '0')
    expect { pay }.not_to change(BilligPaymentError, :count)
  end
  it 'puts tickets on a membership card when one is supplied' do
    member = create(:member)
    BilligTicketCard.create!(card: 123, member: member, membership_ends: 1.year.from_now)
    allow($stdin).to receive(:gets).and_return('y')
    pay(cardnumber: '123')
    expect(BilligTicket.last).to be_on_card
    expect(BilligPurchase.last.member).to eq(member)
  end
end
