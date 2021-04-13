class AddInfoboxPosition < ActiveRecord::Migration[5.2]
  def change
    add_column :info_boxes, :position, :integer
    add_column :info_boxes, :image_state, :boolean
  end
end
