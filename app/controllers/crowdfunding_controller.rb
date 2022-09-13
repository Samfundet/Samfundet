class CrowdfundingController < ApplicationController
  def index
  end

  def new
    pass
  end

  def create
  end

  def update
  end

  def edit
  end

  def destroy
  end

  private
    def crowdfunding_params
      params.require(:crowdfunding).permit(
          :title_no,
          :title_en,
          :ingress_no,
          :ingress_en,
          :vipps,
          :account_number,
          :money_collected,
          :funding_goal,
          :description_private_no,
          :description_private_en,
          :decription_firm_no,
          :description_firm_en
      )
    end

end
