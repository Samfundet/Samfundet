# frozen_string_literal: true
class AddDisabledToApplicants < ActiveRecord::Migration
  def change
    add_column :applicants, :disabled, :boolean, default: false
  end
end
