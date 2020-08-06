# frozen_string_literal: true

class BilligTicketCard < ApplicationRecord
  self.primary_key = :card

  belongs_to :member, foreign_key: :owner_member_id
  has_many :billig_purchases, foreign_key: :owner_member_id, primary_key: :owner_member_id

  def active?
    membership_ends >= Time.zone.today
  end
end

# == Schema Information
#
# Table name: billig_ticket_cards
#
#  card            :bigint           primary key
#  owner_member_id :integer
#  membership_ends :date
#
