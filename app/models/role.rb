# frozen_string_literal: true

require SamfundetAuth::Engine.root.join('app', 'models', 'role')

class Role < ApplicationRecord
  # attr_accessible :group_id, :role_id, :passable

  scope :passable, (lambda do
    Role.where('passable = ?', true)
  end)

  def members
    Member.find(members_roles.all.collect(&:member_id))
  end

  def child_roles
    roles.map(&:sub_roles).flatten
  end

  def sub_roles
    roles + child_roles
  end

  def to_s
    if group
      "#{group.short_name}: #{name}"
    else
      title
    end
  end

  def self.super_user
    Role.find_or_create_by(title: 'lim_web') do |role|
      role.name = 'Superuser',
                  role.description = 'Superrolle for alle i MG::Web.'
    end
  end
end
