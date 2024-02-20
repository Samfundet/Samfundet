# frozen_string_literal: true

class Sulten::ClosedPeriodsController < Sulten::BaseController
  load_and_authorize_resource param_method: :sulten_closed_period_params

  def index
    @current_and_future_closed_times = Sulten::ClosedPeriod.current_and_future_closed_times
  end

  def new
    @closed_period = Sulten::ClosedPeriod.new(
      closed_from: Time.current,
      closed_to: Time.current + 1.week
    )
  end

  def archive
    @previous_closed_periods = Sulten::ClosedPeriod.previous_closed_periods
  end

  def create
    @closed_period = Sulten::ClosedPeriod.new(sulten_closed_period_params)
    if @closed_period.save
      flash[:success] = I18n.t('sulten.closed_periods.creation_success')
      redirect_to sulten_closed_periods_path
    else
      flash.now[:error] = I18n.t('sulten.closed_periods.creation_failure')
      render :new
    end
  end

  def edit; end

  def update
    if @closed_period.update(sulten_closed_period_params)
      flash[:success] = I18n.t('sulten.closed_periods.update_success')
      redirect_to sulten_closed_periods_path
    else
      flash.now[:error] = I18n.t('sulten.closed_periods.update_failure')
      render :edit
    end
  end

  def destroy
    @closed_period.destroy
    flash[:success] = I18n.t('sulten.closed_periods.destruction')
    redirect_to sulten_closed_periods_path
  end

  def sulten_closed_period_params
    params.require(:sulten_closed_period).permit(:message_no, :message_en, :closed_from, :closed_to)
  end
end
