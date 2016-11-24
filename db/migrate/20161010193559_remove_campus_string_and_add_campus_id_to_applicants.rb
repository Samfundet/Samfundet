class RemoveCampusStringAndAddCampusIdToApplicants < ActiveRecord::Migration
  def change
    remove_column :applicants, :campus
    add_column :applicants, :campus_id, :integer
  end
end
