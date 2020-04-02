# frozen_string_literal: true

class GroupType < ApplicationRecord
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
#
# Table name: group_types
#
#  id          :bigint           not null, primary key
#  description :string           not null
#  priority    :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
