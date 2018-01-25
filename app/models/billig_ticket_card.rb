# frozen_string_literal: true

class BilligTicketCard < ActiveRecord::Base
  self.primary_key = :card

  belongs_to :member, foreign_key: :owner_member_id
  has_many :billig_purchases, foreign_key: :owner_member_id, primary_key: :owner_member_id

  # attr_accessible :card, :owner_member_id, :membership_ends
end
