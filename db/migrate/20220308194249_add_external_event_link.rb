class AddExternalEventLink < ActiveRecord::Migration[5.2]
  def change
    add_column :events, :registration_link, :string
  end
end
