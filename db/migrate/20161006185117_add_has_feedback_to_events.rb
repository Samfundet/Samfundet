class AddHasFeedbackToEvents < ActiveRecord::Migration
  def change
    add_column :events, :has_feedback, :boolean
  end
end
