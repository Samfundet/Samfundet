class Sulten::ReservationsController < ApplicationController
  filter_access_to :archive, :export, require: :manage

  def index
    @reservations = Sulten::Reservation.where(reservation_from: Time.now.beginning_of_week..Time.now.end_of_week).order("reservation_from")
  end

  def archive
    @reservations = Sulten::Reservation.where(reservation_from: Time.now.beginning_of_week..Time.now.next_year).order("reservation_from ASC")
  end

  def export
    @reservations = Sulten::Reservation.where(reservation_from: Time.now.beginning_of_week..Time.now.next_year).order("reservation_from ASC")
  end

  def new
    @reservation = Sulten::Reservation.new
  end

  def create
    @reservation = Sulten::Reservation.new(params[:sulten_reservation])
    if @reservation.save
      SultenNotificationMailer.send_reservation_email(@reservation).deliver
      flash[:success] = t("helpers.models.sulten.reservation.success.create")
      redirect_to success_sulten_reservations_path
    else
      flash.now[:error] = t("helpers.models.sulten.reservation.errors.creation_fail")
      render :new
    end
  end

  def available
    available_times = Sulten::Reservation.find_available_times(params[:duration].to_i,
                                             params[:people].to_i,
                                             params[:reservation_type_id].to_i)
    render json: available_times
  end

  def show
    @reservation = Sulten::Reservation.find(params[:id])
  end

  def edit
    @reservation = Sulten::Reservation.find(params[:id])
  end

  def update
    @reservation = Sulten::Reservation.find params[:id]

    if @reservation.update_attributes(params[:sulten_reservation])
      flash[:success] = t("helpers.models.sulten.reservation.success.update")
      redirect_to @reservation
    else
      flash.now[:error] = t("helpers.models.sulten.reservation.errors.update_fail")
      render :edit
    end
  end

  def destroy
    Sulten::Reservation.find(params[:id]).destroy
    flash[:success] = t("helpers.models.sulten.reservation.success.delete")
    redirect_to sulten_reservations_path
  end

  def success
  end
end
