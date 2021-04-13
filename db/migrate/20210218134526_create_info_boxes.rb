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
      t.boolean :image_state
      t.string :color
      t.datetime :start_time
      t.datetime :end_time
      t.timestamps
      t.integer :position
    end
  end
end
