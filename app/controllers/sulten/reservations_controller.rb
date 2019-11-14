# frozen_string_literal: true

class Sulten::ReservationsController < Sulten::BaseController
  load_and_authorize_resource

  def index
    @reservations = Sulten::Reservation.where(reservation_from: Time.zone.now..Time.zone.now.end_of_week).order('reservation_from')
  end

  def archive
    @reservations = Sulten::Reservation.where(reservation_from: Time.zone.now.beginning_of_week..Time.zone.now.next_year).order('reservation_from ASC')
  end

  def export
    @reservations = Sulten::Reservation.where(reservation_from: Time.zone.now.beginning_of_week..Time.zone.now.next_year).order('reservation_from ASC')
    respond_to do |format|
      format.html
      format.csv do
        headers['Content-Disposition'] = "attachment; filename='Reservasjon.csv'"
      end
    end
  end

  def new
    @closed_periods = Sulten::ClosedPeriod.current_and_future_closed_times.sort_by(&:closed_from)
    @reservation = Sulten::Reservation.new
  end

  def admin_new
    @reservation = Sulten::Reservation.new
  end

  def create
    @closed_periods = Sulten::ClosedPeriod.current_and_future_closed_times.sort_by(&:closed_from)
    @reservation = Sulten::Reservation.new(reservation_params)
    if @reservation.in_closed_period?
      flash.now[:error] = t('helpers.models.sulten.reservation.errors.in_closed_period')
      render :new
    elsif @reservation.save
      SultenNotificationMailer.send_reservation_email(@reservation).deliver
      flash[:success] = t('helpers.models.sulten.reservation.success.create')
      redirect_to success_sulten_reservations_path
    else
      flash.now[:error] = t('helpers.models.sulten.reservation.errors.creation_fail')
      render :new
    end
  end

  def admin_create
    # We don't require Lyche admins to type in silly telephone numbers when they manually
    # add a reservation, so just add N/A to signal that it's unecessary. Telephone won't be
    # added from the admin_new view, so we add it here.
    admin_params = reservation_params.merge(telephone: 'N/A')
    @reservation = Sulten::Reservation.new(admin_params)
    @reservation.admin_access = true
    if @reservation.save
      # Note that we don't send an email confimation on manually created reservations.
      # That's only for reservations created by users.
      flash[:success] = t('helpers.models.sulten.reservation.success.create')
      redirect_to sulten_reservations_archive_path
    else
      flash.now[:error] = t('helpers.models.sulten.reservation.errors.creation_fail')
      render :admin_new
    end
  end

  def available
    available_times = Sulten::Reservation.find_available_times(params[:date], params[:duration].to_i, params[:people].to_i, params[:type_id].to_i)
    render json: available_times
  end

  def show
    @reservation = Sulten::Reservation.find(params[:id])
  end

  def edit
    @reservation = Sulten::Reservation.find(params[:id])
  end

  def calendar

    if params[:date] != nil
      @calendar_date = Date.strptime(params[:date], "%d-%m-%Y")
      @is_today = Date.today.beginning_of_day == @calendar_date.beginning_of_day
    else
      @calendar_date = Date.today
      @is_today = true
    end

    start_timeline = @calendar_date.beginning_of_day + 15.hours
    end_timeline = @calendar_date.beginning_of_day + 26.hours
    length_timeline = (end_timeline - start_timeline).seconds

    @reservations = Sulten::Reservation.where(reservation_from: @calendar_date.beginning_of_week..@calendar_date.end_of_week)
    @reservations_today = Sulten::Reservation.where(reservation_from: start_timeline..end_timeline)
    @tables = Sulten::Table.order(:number).all

    @render_reservations = {}

    if @reservations.length == 0
      return
    end

    @reservations.each do |res|
      @render_reservations[res.table_id] = []
    end

    @reservations_today.each do |res|
      offset_percent = ((res.reservation_from - start_timeline).seconds / length_timeline).to_f * 100
      width_percent = ((res.reservation_duration*60) / length_timeline.to_f) * 100
      data = [res, offset_percent, width_percent, offset_percent < 50 ? true : false]
      @render_reservations[res.table_id].insert(0, data)

    end
  end

  def update
    @reservation = Sulten::Reservation.find params[:id]

    if @reservation.update_attributes(reservation_params)
      flash[:success] = t('helpers.models.sulten.reservation.success.update')
      redirect_to @reservation
    else
      flash.now[:error] = t('helpers.models.sulten.reservation.errors.update_fail')
      render :edit
    end
  end

  def destroy
    Sulten::Reservation.find(params[:id]).destroy
    flash[:success] = t('helpers.models.sulten.reservation.success.delete')
    redirect_to sulten_reservations_archive_path
  end

  def success; end

  private

  def reservation_params
    params.require(:sulten_reservation).permit(
      :table_id,
      :people,
      :reservation_from,
      :reservation_duration,
      :name,
      :reservation_type_id,
      :telephone,
      :email,
      :allergies,
      :internal_comment,
      :gdpr_checkbox
    )
  end
end
