# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BilligTicketGroup do
  describe 'availability' do
    [[0, true, false], [64, true, false], [65, true, true], [99, true, true], [100, false, false]].each do |sold, available, few|
      it "reports availability at #{sold}% sold" do
        group = described_class.new(num: 100, num_sold: sold)
        expect(group.tickets_left?).to eq(available)
        expect(group.few_tickets_left).to eq(few)
      end
    end
  end

  [nil, 0, -1, 3].each do |limit|
    it "uses the appropriate limit for #{limit.inspect}" do
      group = described_class.new(ticket_limit: limit)
      expect(group.ticket_limit?).to eq(limit.to_i > 0)
      expect(group.price_group_ticket_limit).to eq(limit.to_i > 0 ? limit : 9)
    end
  end

  it 'filters price groups for online sale and nonmembers independently' do
    group = described_class.create!(num: 10, num_sold: 0)
    online = BilligPriceGroup.create!(billig_ticket_group: group, netsale: true, membership_needed: true)
    offline = BilligPriceGroup.create!(billig_ticket_group: group, netsale: false, membership_needed: false)
    expect(group.netsale_billig_price_groups).to contain_exactly(online)
    expect(group.non_member_price_groups).to contain_exactly(offline)
  end
end
