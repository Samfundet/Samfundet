class AddCrowdFundingSupporters < ActiveRecord::Migration[5.2]
  def change
    create_table :crowd_funding_supporters do |t|
      t.string :name
      t.string :name_short
      t.integer :amount, default: 0
      t.integer :supporter_type
      t.integer :donors, default: 1
    end
  end
end
