# frozen_string_literal: true
class BilligPaymentErrorPriceGroup < ActiveRecord::Base
  # attr_accessible :error, :number_of_tickets, :price_group
  belongs_to :billig_price_group, foreign_key: :price_group

  def samfundet_event
    billig_price_group
      .billig_ticket_group
      .billig_event
      .samfundet_event
  end
end
