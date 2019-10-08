class AddCodewordToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :codeword, :string, null: true
  end
end
