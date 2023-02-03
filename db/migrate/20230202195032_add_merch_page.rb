class AddMerchPage < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
    t.string :name_no
    t.string :name_en
    t.integer :price
    t.integer :image_id
    end

    create_table :product_variations do |t|
      t.string :specification
      t.integer :quantity
    end
  end
end
