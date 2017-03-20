class AddTimestampToMembersRole < ActiveRecord::Migration
  def change
    add_column :members_roles, :created_at, :datetime, null: false, default: '2017-01-26 21:50:05'
    add_column :members_roles, :updated_at, :datetime, null: false, default: '2017-01-26 21:50:05'
  end
end
