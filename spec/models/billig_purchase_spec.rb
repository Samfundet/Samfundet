# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BilligPurchase do
  it 'finds the owner and membership card by member ID' do
    member = create(:member)
    card = BilligTicketCard.create!(card: 123, member: member, membership_ends: 1.year.from_now)
    purchase = BilligPurchase.create!(member: member, owner_email: member.mail)
    expect(purchase.member).to eq(member)
    expect(purchase.membership_card).to eq(card)
    expect(card.billig_purchases).to contain_exactly(purchase)
  end
end
