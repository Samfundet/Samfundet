# frozen_string_literal: true
class AddEnglishAndNorwegianTextToEverythingCloserPeriods < ActiveRecord::Migration
  def change
    rename_column :everything_closed_periods, :message, :message_no
    change_column :everything_closed_periods, :message_no, :text
    add_column :everything_closed_periods, :message_en, :text
  end
end
