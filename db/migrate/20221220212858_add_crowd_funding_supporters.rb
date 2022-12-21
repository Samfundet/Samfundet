class AddCrowdFundingSupporters < ActiveRecord::Migration[5.2]
  def change
    create_table :crowd_funding_supporters do |t|
      t.string :name
      t.integer :amount, default: 0
      t.integer :supporter_type
    end
  end
end
