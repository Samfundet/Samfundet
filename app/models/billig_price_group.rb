# frozen_string_literal: true

class BilligPriceGroup < ApplicationRecord
  self.primary_key = :price_group
  # attr_accessible :can_be_put_on_card, :membership_needed, :netsale, :price, :price_group, :price_group_name, :ticket_group

  has_many :billig_payment_error_price_groups, foreign_key: :price_group
  belongs_to :billig_ticket_group, foreign_key: :ticket_group
end

# == Schema Information
#
# Table name: billig_price_groups
#
#  price_group        :bigint           not null, primary key
#  can_be_put_on_card :boolean
#  membership_needed  :boolean
#  netsale            :boolean
#  price              :integer
#  price_group_name   :string
#  ticket_group       :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
