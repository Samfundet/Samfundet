class CreateRapidTests < ActiveRecord::Migration[5.2]
  def change
    create_table :rapid_tests do |t|
      t.integer :amount
      t.string :name
      t.datetime :date

      t.timestamps
    end
  end
end
