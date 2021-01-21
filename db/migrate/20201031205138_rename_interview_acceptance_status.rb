class RenameInterviewAcceptanceStatus < ActiveRecord::Migration[5.2]
  def change
    rename_column :interviews, :acceptance_status, :priority
    add_column :interviews, :applicant_status, :string
  end
end
