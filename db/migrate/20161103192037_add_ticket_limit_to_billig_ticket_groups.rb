class AddTicketLimitToBilligTicketGroups < ActiveRecord::Migration[5.1]
  def change
    add_column :billig_ticket_groups, :ticket_limit, :integer
  end
end
