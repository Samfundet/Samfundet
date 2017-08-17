class FixMemberRoleTimestamp < ActiveRecord::Migration
  def change
  	change_column_default :members_roles, :created_at, nil
  	change_column_default :members_roles, :updated_at, nil
  end
end
