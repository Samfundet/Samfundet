class AddMerchPage < ActiveRecord::Migration[5.2]
  def change
    create_table :products do |t|
    t.string :name_no
    t.string :name_en
    t.integer :price
    t.integer :image_id
    t.boolean :has_variations, default: true
    t.integer :amount, default: 0
    t.datetime :release_time
    end

    create_table :product_variations do |t|
      t.string :name
      t.integer :amount, default: 0
      t.integer :product_id
    end

    create_table :orders do |t|
      t.string :name
      t.string :email
      t.boolean :processed, default: false
    end

    create_table :order_products do |t|
      t.integer :product_id
      t.integer :product_variation_id
      t.integer :order_id
      t.integer :amount
    end
  end
end
