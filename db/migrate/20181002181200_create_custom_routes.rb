class CreateCustomRoutes < ActiveRecord::Migration[5.0]
  def change
    create_table :custom_routes do |t|
      t.string :name
      t.string :source, unique: true
      t.string :target
      t.string :comment

      t.timestamps
    end
  end
end
