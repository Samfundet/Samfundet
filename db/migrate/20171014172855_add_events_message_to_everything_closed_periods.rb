class AddEventsMessageToEverythingClosedPeriods < ActiveRecord::Migration
  def change
    add_column :everything_closed_periods, :event_message_no, :text
    add_column :everything_closed_periods, :event_message_en, :text
  end
end
