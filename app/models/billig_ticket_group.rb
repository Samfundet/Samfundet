# frozen_string_literal: true

class BilligTicketGroup < ApplicationRecord
  DEFAULT_TICKET_LIMIT = 9

  self.primary_key = :ticket_group
  # attr_accessible :event, :is_theater_ticket_group, :num, :num_sold, :ticket_group, :ticket_group_name, :ticket_limit

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

  def ticket_limit?
    !ticket_limit.nil? && ticket_limit.positive?
  end

  def price_group_ticket_limit
    if !ticket_limit?
      DEFAULT_TICKET_LIMIT
    else
      ticket_limit
    end
  end
end

# == Schema Information
#
# Table name: billig_ticket_groups
#
#  ticket_group            :bigint           not null, primary key
#  event                   :integer
#  is_theater_ticket_group :boolean
#  num                     :integer
#  num_sold                :integer
#  ticket_group_name       :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  ticket_limit            :integer
#
