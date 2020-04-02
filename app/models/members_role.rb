# frozen_string_literal: true

class MembersRole < ApplicationRecord
  validates :member_id, presence: true
  validates :role_id, presence: true
  # attr_accessible :created_at, :member, :role

  belongs_to :member, touch: true
  belongs_to :role
end

# == Schema Information
#
# Table name: members_roles
#
#  id         :bigint           not null, primary key
#  member_id  :integer
#  role_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
