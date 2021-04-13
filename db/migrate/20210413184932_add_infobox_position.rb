class AddInfoboxPosition < ActiveRecord::Migration[5.2]
  def change
    add_column :info_boxes, :position, :integer
  end
end
