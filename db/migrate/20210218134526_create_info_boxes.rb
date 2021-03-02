class CreateInfoBoxes < ActiveRecord::Migration[5.2]
  def change
    create_table :info_boxes do |t|
      t.string :title_no
      t.string :title_en
      t.text :body_no
      t.text :body_en
      t.string :link_no
      t.string :link_en
      t.integer :image_id
      t.timestamps
    end
  end
end
