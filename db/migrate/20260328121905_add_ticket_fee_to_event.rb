class AddTicketFeeToEvent < ActiveRecord::Migration[6.1]
  def change
    change_table :billig_events do |t|
      t.integer :ticket_fee, null: true
    end
  end
end
