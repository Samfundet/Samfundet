# -*- encoding : utf-8 -*-
class GroupType < ActiveRecord::Base
  has_many :groups, order: 'name'
  has_many :jobs, through: :groups

  validates_presence_of :description
  validates :description, uniqueness: true

  default_scope order: "priority DESC"

  def <=>(other)
    priority <=> other.priority
  end

  def to_s
    description
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: group_types
#
#  id          :integer          not null, primary key
#  description :string(255)      not null
#  priority    :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
