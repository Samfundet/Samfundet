class CreateEmailVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :email_verifications do |t|
      t.string :verification_hash, null: false
      t.integer :count, default: 1, null: false
      t.integer :applicant_id, null: false

      t.timestamps
    end
    add_foreign_key :email_verifications, :applicants, column: :applicant_id
  end
end
