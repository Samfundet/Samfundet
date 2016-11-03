class BilligTicketGroup < ActiveRecord::Base
  self.primary_key = :ticket_group
  attr_accessible :event, :is_theater_ticket_group, :num, :num_sold, :ticket_group, :ticket_group_name, :ticket_limit

  belongs_to :billig_event, foreign_key: :event
  has_many :billig_price_groups, foreign_key: :ticket_group

  def netsale_billig_price_groups
    billig_price_groups.where(netsale: true)
  end

  def tickets_left?
    num_sold < num
  end

  def few_tickets_left
    num_sold.between?(num * 0.65, num - 1)
  end

  def has_ticket_limit?
    !ticket_limit.nil? && ticket_limit > 0
  end
end