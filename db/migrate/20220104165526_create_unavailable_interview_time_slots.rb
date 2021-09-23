class CreateUnavailableInterviewTimeSlots < ActiveRecord::Migration[5.2]
  def change
    create_table :unavailable_interview_time_slots do |t|
      t.datetime :start_time
      t.datetime :end_time
      t.integer :admission_id
      t.integer :applicant_id

      t.timestamps
    end
    add_foreign_key :unavailable_interview_time_slots, :admissions, column: :admission_id
    add_foreign_key :unavailable_interview_time_slots, :applicants, column: :applicant_id
  end
end
