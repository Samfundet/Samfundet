class CreateRegistrationEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :registration_events do |t|
      t.integer :arrangement_id
      t.integer :plasser
    end
    add_foreign_key :registration_events, :events, column: :arrangement_id
  end
end
