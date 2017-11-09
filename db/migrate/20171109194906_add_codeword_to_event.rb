class AddCodewordToEvent < ActiveRecord::Migration
  def change
    add_column :events, :codeword, :string, null: true
  end
end
