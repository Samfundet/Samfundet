class AddActiveBooleanToCampus < ActiveRecord::Migration
  def change
    add_column :campus, :active, :boolean, default: true
  end
end
