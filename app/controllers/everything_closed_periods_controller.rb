# frozen_string_literal: true
class EverythingClosedPeriodsController < ApplicationController
  filter_access_to :all

  def index
    @current_and_future_closed_times = EverythingClosedPeriod.current_and_future_closed_times
  end

  def new
    @everything_closed_period = EverythingClosedPeriod.new(
      closed_from: DateTime.current,
      closed_to: DateTime.current + 1.week
    )
  end

  def create
    @everything_closed_period = EverythingClosedPeriod.new(params[:everything_closed_period])
    if @everything_closed_period.save
      flash[:success] = I18n.t('everything_closed_periods.creation_success')
      redirect_to everything_closed_periods_path
    else
      flash.now[:error] = I18n.t('everything_closed_periods.creation_failure')
      render :new
    end
  end

  def edit
    @everything_closed_period = EverythingClosedPeriod.find params[:id]
  end

  def update
    @everything_closed_period = EverythingClosedPeriod.find(params[:id])
    if @everything_closed_period.update_attributes(params[:everything_closed_period])
      flash[:success] = I18n.t('everything_closed_periods.update_success')
      redirect_to everything_closed_periods_path
    else
      flash.now[:error] = I18n.t('everything_closed_periods.update_failure')
      render :edit
    end
  end

  def destroy
    @everything_closed_period = EverythingClosedPeriod.find params[:id]
    @everything_closed_period.destroy
    flash[:success] = I18n.t('everything_closed_periods.destruction')
    redirect_to everything_closed_periods_path
  end
end
