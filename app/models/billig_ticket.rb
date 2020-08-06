# frozen_string_literal: true

class BilligTicket < ApplicationRecord
  self.primary_key = :ticket
  # attr_accessible :ticket, :price_group, :purchase,
  #                :used, :refunder, :on_card, :refunder, :point_of_refund

  belongs_to :billig_price_group, foreign_key: :price_group
  belongs_to :billig_purchase, foreign_key: :purchase

  def billig_event
    billig_price_group
      .billig_ticket_group
      .billig_event
  end
end

# == Schema Information
#
# Table name: billig_tickets
#
#  ticket          :bigint           not null, primary key
#  price_group     :integer          not null
#  purchase        :integer          not null
#  used            :datetime
#  refunded        :datetime
#  on_card         :boolean          not null
#  refunder        :text
#  point_of_refund :integer
#
