class RemoveColumnFromFeedbackQuestion < ActiveRecord::Migration
  def up
    remove_column :feedback_questions, :feedbacks_id
  end

  def down
    add_column :feedback_questions, :feedbacks, :references
  end
end
