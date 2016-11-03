class AddTicketLimitToBilligTicketGroups < ActiveRecord::Migration
  def change
    add_column :billig_ticket_groups, :ticket_limit, :integer
  end
end
