class AddCustomizedGroupToAdmission < ActiveRecord::Migration[5.2]
  def change
    add_column :admissions, :customized_groups, :boolean, default: false
  end
end
