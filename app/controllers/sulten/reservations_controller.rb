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
    @reservation = Sulten::Reservation.new(reservation_params)
    @reservation.admin_access = true
    if @reservation.save
      SultenNotificationMailer.send_reservation_email(@reservation).deliver
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
    puts "******** CALENDAR FUNC *************"
    start_timeline = Time.zone.now.beginning_of_day + 15.hours
    end_timeline = Time.zone.now.beginning_of_day + 24.hours
    length_timeline = end_timeline - start_timeline

    @reservations = Sulten::Reservation.where(reservation_from: start_timeline..end_timeline)
    @render_offsets = []
    @render_widths = []

    @reservations.each do |res|
      offset_percent = ((res.reservation_from - start_timeline) / length_timeline).to_f * 100
      @render_offsets.insert(@render_offsets.length, offset_percent)

      width_percent = ((res.reservation_duration*60) / length_timeline.to_f) * 100
      @render_widths.insert(@render_widths.length, width_percent)

      puts "into day: "+((res.reservation_from - Time.zone.now.beginning_of_day).to_f/60).to_s + "/" + (24.hours.to_f).to_s + " => "+ offset_percent.to_s

      puts " START OF DAY "+Time.zone.now.beginning_of_day.to_s
      puts " START OF RES "+res.reservation_from.to_s
      puts " DIFFERENCE   "+(res.reservation_from - Time.zone.now.beginning_of_day).to_s

    end

    @tables = Sulten::Table.order(:number).all

    puts "CALENDAR INIT FOUND "+@reservations.length.to_s+" reservations!!"
    puts "between "+Time.zone.now.beginning_of_day.to_s+" to "+Time.zone.now.end_of_day.to_s
    puts "******** CALENDAR FUNC END *************"
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
