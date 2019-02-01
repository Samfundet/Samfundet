# frozen_string_literal: true

require SamfundetAuth::Engine.root.join('app', 'models', 'member')

class Member < ActiveRecord::Base
  has_many :blogs, foreign_key: 'author_id'
  has_one :membership_card, class_name: 'BilligTicketCard', foreign_key: :owner_member_id
  has_many :billig_purchase, foreign_key: :owner_member_id

  def sub_roles
    roles + roles.map(&:sub_roles).flatten
  end
end
