class AddInterviewTimeSlot < ActiveRecord::Migration[5.2]
  def change
    create_table :interview_time_slots do |t|
      t.integer :job_id, null: false
      t.integer :group_id, null: false
      t.integer :admission_id, null: false
      t.string :location
      t.string :comment
      t.datetime :start_time
      t.datetime :end_time

      t.timestamps
    end
    add_foreign_key :interview_time_slots, :jobs, column: :job_id
    add_foreign_key :interview_time_slots, :groups, column: :group_id
    add_foreign_key :interview_time_slots, :admissions, column: :admission_id
  end
end
