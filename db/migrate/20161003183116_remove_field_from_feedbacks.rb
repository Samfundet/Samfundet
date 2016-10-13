class RemoveFieldFromFeedbacks < ActiveRecord::Migration
  def up
    remove_column :feedbacks, :event_id
  end

  def down
    add_column :feedbacks, :event_id, :integer
  end
end
