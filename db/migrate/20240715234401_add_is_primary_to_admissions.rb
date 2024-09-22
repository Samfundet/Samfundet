class AddIsPrimaryToAdmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :admissions, :is_primary, :boolean, default: false
  end
end
