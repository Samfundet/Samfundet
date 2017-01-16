class AddTokenToFeedbackAnswer < ActiveRecord::Migration
  def change
    add_column :feedback_answers, :token, :string
  end
end
