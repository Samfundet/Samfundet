class AddColumnToEvents < ActiveRecord::Migration
  def change
    add_column :events, :feedback_id, :integer
  end
end
