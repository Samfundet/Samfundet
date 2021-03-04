class AddInformationToAreas < ActiveRecord::Migration[5.2]
  def change
    add_column :areas, :description_no, :text
    add_column :areas, :description_en, :text
    add_column :areas, :age_limit_no, :string
    add_column :areas, :age_limit_en, :string
    add_column :areas, :image_id, :integer
  end
end
