class AddSultenClosedPeriod < ActiveRecord::Migration[5.0]
  def change
    create_table :sulten_closed_periods do |t|
      t.string 'message_no'
      t.string 'message_en'
      t.datetime 'closed_from'
      t.datetime 'closed_to'
    end
  end
end
