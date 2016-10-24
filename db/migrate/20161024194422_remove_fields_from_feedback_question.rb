class RemoveFieldsFromFeedbackQuestion < ActiveRecord::Migration
  def up
    remove_column :feedback_questions, :alternative_1
    remove_column :feedback_questions, :alternative_2
    remove_column :feedback_questions, :alternative_3
    remove_column :feedback_questions, :alternative_4
  end

  def down
    add_column :feedback_questions, :alternative_1, :string
    add_column :feedback_questions, :alternative_2, :string
    add_column :feedback_questions, :alternative_3, :string
    add_column :feedback_questions, :alternative_4, :string
  end
end
