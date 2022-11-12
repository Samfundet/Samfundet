class AddInterviewTimeSlotIdToInterview < ActiveRecord::Migration[5.2]
  def change
    add_column :interviews, :interview_time_slot_id, :integer
    add_foreign_key :interviews, :interview_time_slots, column: :interview_time_slot_id
  end
end
