class AddColumnToFeedbacks < ActiveRecord::Migration
  def change
    add_column :feedbacks, :title, :string
  end
end
