class AddAutomaticRejectionEmailTable < ActiveRecord::Migration[5.2]
  def change
    create_table :rejection_emails do |t|
      t.integer :admission_id
      t.integer :applicant_id
      t.datetime :sent_at, null: false
    end
    add_foreign_key :rejection_emails, :admissions, column: :admission_id, name: "rejection_emails_admission_id_fk"
    add_foreign_key :rejection_emails, :applicants, column: :applicant_id, name: "rejection_emails_applicant_id_fk"
  end
end
