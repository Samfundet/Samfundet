class AddExternalOrganizerLinkToEvents < ActiveRecord::Migration[6.1]
  def change
    change_table :events do |t|
      t.string :external_organizer_link, null: true
    end
  end
end
