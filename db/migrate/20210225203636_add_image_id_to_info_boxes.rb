class AddImageIdToInfoBoxes < ActiveRecord::Migration[5.2]
  def change
    add_column :info_boxes, :image_id, :int
  end
end
