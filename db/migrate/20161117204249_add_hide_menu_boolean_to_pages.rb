class AddHideMenuBooleanToPages < ActiveRecord::Migration
  def change
    add_column :pages, :hide_menu, :boolean, default: false
  end
end
