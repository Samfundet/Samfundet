# frozen_string_literal: true
class AddInterestedOtherPositionsToApplicant < ActiveRecord::Migration
  def change
    add_column :applicants, :interested_other_positions, :boolean
  end
end
