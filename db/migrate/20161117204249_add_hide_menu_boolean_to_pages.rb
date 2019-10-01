class AddHideMenuBooleanToPages < ActiveRecord::Migration[5.1]
  def change
    add_column :pages, :hide_menu, :boolean, default: false
  end
end
