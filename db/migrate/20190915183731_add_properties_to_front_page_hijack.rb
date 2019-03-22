class AddPropertiesToFrontPageHijack < ActiveRecord::Migration[5.0]
  def change
    add_column :front_page_hijacks, :background_color, :string
    add_column :front_page_hijacks, :text_color, :string
  end
end
