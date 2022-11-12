class AddColumnsToJobs < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :interview_interval, :integer, null: false, default: 30
    add_column :jobs, :contact_email, :string
    add_column :jobs, :contact_phone, :string
    add_column :jobs, :linkable_interviews, :boolean, null: false, default: false
  end
end
