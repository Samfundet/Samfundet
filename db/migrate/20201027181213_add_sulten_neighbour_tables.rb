class AddSultenNeighbourTables < ActiveRecord::Migration[5.2]
  def change
    create_table :sulten_neighbour_tables do |t|
      t.integer :table_id
      t.integer :neighbour_id
    end
    add_foreign_key :sulten_neighbour_tables, :sulten_tables, column: :table_id
    add_foreign_key :sulten_neighbour_tables, :sulten_tables, column: :neighbour_id
  end
end
