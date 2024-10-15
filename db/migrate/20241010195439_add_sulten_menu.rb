class AddSultenMenu < ActiveRecord::Migration[6.1]
  def change
    create_table :sulten_menu_items do |t|
      t.string :title_no
      t.string :title_en
      t.text :description_no
      t.text :description_en
      t.string :allergies_no
      t.string :allergies_en
      t.string :additional_info_no, null: true
      t.string :additional_info_en, null: true
      t.string :recommendation, null: true
      t.integer :price
      t.integer :price_member
      t.references :category, foreign_keys: { to_table: :sulten_menu_categories }
      t.integer :order
    end

    create_table :sulten_menu_categories do |t|
      t.string :title_en
      t.string :title_no
      t.integer :order
    end
  end
end
