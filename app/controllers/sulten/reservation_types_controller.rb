# frozen_string_literal: true

class Sulten::ReservationTypesController < Sulten::BaseController
  load_and_authorize_resource

  def index
    @types = Sulten::ReservationType.all
  end

  def new
    @type = Sulten::ReservationType.new
  end

  def show
    @type = Sulten::ReservationType.find(params[:id])
  end

  def edit
    @type = Sulten::ReservationType.find(params[:id])
  end

  def update
    @type = Sulten::ReservationType.find(params[:id])
    if @type.update_attributes(reservation_type_params)
      redirect_to sulten_reservation_types_path
    else
      render :edit
    end
  end

  def destroy
    Sulten::ReservationType.find(params[:id]).destroy
    redirect_to sulten_reservation_types_path
  end

  def create
    @type = Sulten::ReservationType.new(reservation_type_params)
    if @type.save
      flash[:success] = t('helpers.models.sulten.reservation_type.success.create')
      redirect_to @type
    else
      flash.now[:error] = t('helpers.models.sulten.reservation_type.errors.create')
      render :new
    end
  end

  private

  def reservation_type_params
    params.require(:sulten_reservation_type).permit(:name, :description)
  end
end
