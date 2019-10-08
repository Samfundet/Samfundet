class AddActiveBooleanToCampus < ActiveRecord::Migration[5.1]
  def change
    add_column :campus, :active, :boolean, default: true
  end
end
