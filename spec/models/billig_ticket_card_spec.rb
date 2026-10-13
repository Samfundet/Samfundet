# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BilligTicketCard do
  [-1, 0, 1].each do |offset|
    it "checks membership ending #{offset} days from today" do
      card = described_class.new(membership_ends: Date.current + offset)
      expect(card.active?).to eq(offset >= 0)
    end
  end
end
