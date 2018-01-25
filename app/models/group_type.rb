# frozen_string_literal: true

class GroupType < ActiveRecord::Base
  has_many :groups, -> { order(:name) }
  has_many :jobs, through: :groups

  validates :description, presence: true
  validates :description, uniqueness: true

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
