# frozen_string_literal: true

class BilligPaymentErrorPriceGroup < ApplicationRecord
  # attr_accessible :error, :number_of_tickets, :price_group
  belongs_to :billig_price_group, foreign_key: :price_group

  def samfundet_event
    billig_price_group
      .billig_ticket_group
      .billig_event
      .samfundet_event
  end
end

# == Schema Information
#
# Table name: billig_payment_error_price_groups
#
#  error             :string
#  price_group       :integer
#  number_of_tickets :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
