require SamfundetAuth::Engine.root.join('app', 'models', 'role')

class Role < ActiveRecord::Base
  #attr_accessible :group_id, :role_id, :passable

  scope :passable, (lambda do
    Role.where("passable = ?", true)
  end)

  def members
    Member.find(members_roles.all.collect(&:member_id))
  end

  def sub_roles
    roles + roles.map(&:sub_roles).flatten
  end

  def self.super_user
    Role.find_or_create_by(title: "lim_web") do |role|
      role.name = "Superuser",
      role.description = "Superrolle for alle i MG::Web."
    end
  end
end
