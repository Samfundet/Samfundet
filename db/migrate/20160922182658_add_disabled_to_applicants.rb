# frozen_string_literal: true
class AddDisabledToApplicants < ActiveRecord::Migration[5.1]
  def change
    add_column :applicants, :disabled, :boolean, default: false
  end
end
