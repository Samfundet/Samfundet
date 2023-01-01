class AddInterviewGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :interview_groups do |t|
      t.integer :group_id
      t.integer :admission_id
      t.string :name
      t.string :description
    end
    add_foreign_key :interview_groups, :groups, column: :group_id, name: "interview_groups_group_id_fk"
    add_foreign_key :interview_groups, :admissions, column: :admission_id, name: "interview_groups_admission_id_fk"
  end
end
