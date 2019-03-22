class AddLocalizedMessageToFrontPageHijack < ActiveRecord::Migration[5.0]
  def change
    add_column :front_page_hijacks, :message_no, :text
    add_column :front_page_hijacks, :message_en, :text
    remove_column :front_page_hijacks, :message, :text
  end
end
