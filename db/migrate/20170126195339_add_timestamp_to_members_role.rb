class AddTimestampToMembersRole < ActiveRecord::Migration
  def change
    add_column :members_roles, :created_at, :datetime, null: false, default: DateTime.now
    add_column :members_roles, :updated_at, :datetime, null: false, default: DateTime.now
  end
end
