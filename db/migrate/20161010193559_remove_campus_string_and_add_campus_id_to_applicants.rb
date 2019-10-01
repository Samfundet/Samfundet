class RemoveCampusStringAndAddCampusIdToApplicants < ActiveRecord::Migration[5.1]
  def change
    remove_column :applicants, :campus
    add_column :applicants, :campus_id, :integer
  end
end
