class SultenLycheOpeningHours < ActiveRecord::Migration
  def change
    create_table :sulten_lyche_opening_hours do |t|
      t.time :openLyche
      t.time :closeLyche
      t.time :openKitchen
      t.time :closeKitchen

      t.timestamps

    add_column :sulten_lyche_opening_hours, :day_number, :integer
    add_column :sulten_reservation_types, :needs_kitchen, :boolean
  end
end
