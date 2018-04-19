class RemoveStartMsgFromFeedback < ActiveRecord::Migration
  def change
    remove_column :feedback_surveys, :start_message
  end
end
