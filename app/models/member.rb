# frozen_string_literal: true

require SamfundetAuth::Engine.root.join('app', 'models', 'member')

class Member < ApplicationRecord
  has_many :blogs, foreign_key: 'author_id'
  has_one :membership_card, class_name: 'BilligTicketCard', foreign_key: :owner_member_id
  has_many :billig_purchase, foreign_key: :owner_member_id

  def child_roles
    roles.map(&:sub_roles).flatten
  end

  def sub_roles
    roles + child_roles
  end

  def active_membership?
    !membership_card.nil? && membership_card.active?
  end
end
