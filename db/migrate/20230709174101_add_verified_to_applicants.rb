class AddVerifiedToApplicants < ActiveRecord::Migration[5.2]
  def change
    add_column :applicants, :verified, :boolean, default: false, null: false
  end
end
