class BilligPriceGroup < ActiveRecord::Base
  self.primary_key = :price_group
  # attr_accessible :can_be_put_on_card, :membership_needed, :netsale, :price, :price_group, :price_group_name, :ticket_group

  has_many :billig_payment_error_price_groups, foreign_key: :price_group
  belongs_to :billig_ticket_group, foreign_key: :ticket_group
end
