class AddInterviewGroupIdToJob < ActiveRecord::Migration[5.2]
  def change
    add_column :jobs, :interview_group_id, :integer
    add_foreign_key :jobs, :interview_groups, column: :interview_group_id, name: "jobs_interview_group_id_fk"
  end
end
