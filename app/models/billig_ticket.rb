# frozen_string_literal: true

class BilligTicket < ActiveRecord::Base
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
