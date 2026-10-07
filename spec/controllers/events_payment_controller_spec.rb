# frozen_string_literal: true

require 'rails_helper'
RSpec.describe EventsController, type: :controller do
  let(:event) { create(:event) }
  let(:billig) { BilligEvent.create!(event_name: 'Concert', sale_from: 1.day.ago, sale_to: 1.day.from_now) }
  let(:group) { BilligTicketGroup.create!(billig_event: billig, num: 100, num_sold: 0, ticket_limit: 3) }
  let(:price) { BilligPriceGroup.create!(billig_ticket_group: group, price: 100, netsale: true, membership_needed: false) }
  before do
    Rails.application.config.billig_offline = false
    price
    event.update_columns(billig_event_id: billig.id, price_type: 'billig')
  end
  it 'offers online ticket groups and nonmember purchases' do
    get :buy, params: { id: event.id }
    expect(assigns(:ticket_groups)).to eq([group])
    expect(assigns(:non_member_ticket_available)).to be(true)
    expect(assigns(:payment_error)).to be_nil
  end
  it 'displays failed purchase details with the previous ticket quantities' do
    BilligPaymentError.create!(error: 'failed', message: 'Invalid card')
    BilligPaymentErrorPriceGroup.create!(error: 'failed', price_group: price.id, number_of_tickets: 2)
    get :buy, params: { id: event.id, bsession: 'failed' }, xhr: true
    expect(assigns(:payment_error_price_groups)).to eq(price.id => 2)
    expect(flash[:error]).to eq('Invalid card')
  end
  it 'rejects AJAX purchase requests when sales have ended' do
    billig.update!(sale_to: 1.day.ago)
    expect { get :buy, params: { id: event.id }, xhr: true }.to raise_error(ActionController::RoutingError)
  end
  it 'redirects payment errors for known price groups back to their event' do
    BilligPaymentErrorPriceGroup.create!(error: 'failed', price_group: price.id, number_of_tickets: 2)
    get :purchase_callback_failure, params: { bsession: 'failed' }
    expect(response).to redirect_to(buy_event_path(event, bsession: 'failed'))
  end
  it 'redirects recorded payment errors even without price group details' do
    BilligPaymentError.create!(error: 'failed', message: 'Invalid card')
    get :purchase_callback_failure, params: { bsession: 'failed' }
    expect(response).to redirect_to(root_path(bsession: 'failed'))
  end
  it 'redirects recorded errors with price group details to the purchase form' do
    BilligPaymentError.create!(error: 'failed', message: 'Invalid card')
    BilligPaymentErrorPriceGroup.create!(error: 'failed', price_group: price.id, number_of_tickets: 2)
    get :purchase_callback_failure, params: { bsession: 'failed' }
    expect(response).to redirect_to(buy_event_path(event, bsession: 'failed'))
  end
  it 'deduplicates purchased references and calculates the total ticket price' do
    Rails.application.config.purchase_callback_google_form_enabled = false
    Rails.application.config.purchase_callback_google_form_url = ''
    Rails.application.config.billig_ticket_path = 'https://tickets.example/pdf?'
    purchase = BilligPurchase.create!(owner_email: 'buyer@example.com')
    ticket = BilligTicket.create!(billig_price_group: price, billig_purchase: purchase, on_card: false)
    reference = "#{ticket.id}12345"
    get :purchase_callback_success, params: { tickets: "#{reference},#{reference},0" }
    expect(assigns(:sum)).to eq(100)
    expect(assigns(:ticket_event_price_group_card_no).length).to eq(1)
    expect(assigns(:pdf_url)).to eq("https://tickets.example/pdf?ticket0=#{reference}")
  end
end
