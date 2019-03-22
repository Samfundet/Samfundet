class CreateFrontPageHijacks < ActiveRecord::Migration[5.0]
  def change
    create_table :front_page_hijacks do |t|
      t.text :message
      t.datetime :shown_from
      t.datetime :shown_to

      t.timestamps
    end
  end
end
