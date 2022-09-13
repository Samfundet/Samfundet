class Crowdfunding < ApplicationRecord

  validates :title_no, :title_en, :ingress_no, :ingress_en, :vipps, :account_number, :money_collected, :funding_goal,
            :description_private_no, :description_private_en, :decription_firm_no, :description_firm_en, presence: true

end
