# frozen_string_literal: true

class BilligPurchase < ApplicationRecord
  self.primary_key = :purchase

  # This table has many more fields,
  # but none we are interested in
  # attr_accessible :owner_member_id, :owner_email

  belongs_to :member, foreign_key: :owner_member_id
  has_one :membership_card, class_name: 'BilligTicketCard', foreign_key: :owner_member_id, primary_key: :owner_member_id

  has_one :billig_ticket
end

# == Schema Information
#
# Table name: billig_purchases
#
#  purchase        :bigint           not null, primary key
#  owner_member_id :integer
#  owner_email     :string
#
