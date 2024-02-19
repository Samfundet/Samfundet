class AddCustomGroupAndCustomGroupTypeToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :custom_group, :string, default: ""
    add_column :jobs, :custom_group_type, :string, default: ""
  end
end
