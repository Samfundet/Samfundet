class CreateFeedbackAlternatives < ActiveRecord::Migration
  def change
    create_table :feedback_alternatives do |t|
      t.string :text
      t.integer :question_id

      t.timestamps
    end
  end
end
