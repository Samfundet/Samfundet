class AddColumnToFeedbackAnswer < ActiveRecord::Migration
  def change
    add_column :feedback_answers, :question_id, :integer
  end
end
