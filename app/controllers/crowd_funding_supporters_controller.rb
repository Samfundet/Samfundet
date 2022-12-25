# frozen_string_literal: true

class CrowdFundingSupportersController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, CrowdFundingSupporter }
  def index
    @supporters_union = CrowdFundingSupporter.limit(5).order('amount desc').where(supporter_type: :student_union)
    @supporters_group = CrowdFundingSupporter.order('amount desc').where(supporter_type: :group)

    @supporter_group_per = CrowdFundingSupporter.where(supporter_type: :group).sort { |a, b| (a.amount / a.donors) <=> (b.amount / b.donors) }.reverse

    @largest = (CrowdFundingSupporter.order('amount').last).amount
    @points = [0, @largest/4, @largest/2, (@largest*3)/4, @largest]
  end

  def admin
    @supporters = CrowdFundingSupporter.all.sort
  end

  def new
    @supporter = CrowdFundingSupporter.new
  end

  def create
    @supporter = CrowdFundingSupporter.new(crowd_funding_supporter_params)
    if @supporter.save
      redirect_to admin_crowd_funding_supporters_path
    else
      render :new
    end
  end
  def edit
    @supporter = CrowdFundingSupporter.find(params[:id])
  end

  def update
    @supporter = CrowdFundingSupporter.find(params[:id])

    if @supporter.update(crowd_funding_supporter_params)
      redirect_to admin_crowd_funding_supporters_path
    else
      render :edit
    end
  end

  def destroy
    @supporter = CrowdFundingSupporter.find(params[:id])
    @supporter.destroy
    redirect_to admin_crowd_funding_supporters_path
  end

  def admin_applet
  end

private

  def crowd_funding_supporter_params
    params.require(:crowd_funding_supporter).permit(
      :name,
      :supporter_type,
      :amount,
      :donors
    )
  end
end
