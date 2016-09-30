class AddColumnToFeedbackQuestion < ActiveRecord::Migration
  def change
    add_column :feedback_questions, :feedback_id, :integer
  end
end
