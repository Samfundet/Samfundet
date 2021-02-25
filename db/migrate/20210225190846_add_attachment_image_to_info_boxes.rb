class AddAttachmentImageToInfoBoxes < ActiveRecord::Migration[5.0]
  def self.up
    change_table :info_boxes do |t|
      t.attachment :image
      t.string :link
    end
  end

  def self.down
    remove_attachment :info_boxes, :image
  end
end
