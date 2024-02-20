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
    from_s = reservation_params[:reservation_from] + ' ' + reservation_params[:reservation_duration]
    from = Time.parse(from_s)
    to = from + 120.minutes
    people = reservation_params[:people].to_i
    type = reservation_params[:reservation_type_id].to_i

    params = {
        reservation_from: from_s,
        reservation_duration: 120,
        reservation_type_id: type,
        people: people,
        name: reservation_params[:name],
        telephone: reservation_params[:telephone],
        email: reservation_params[:email],
        allergies: reservation_params[:allergies],
        gdpr_checkbox: reservation_params[:gdpr_checkbox]
    }

    # Not one day in future
    if from < Date.tomorrow
      redirect_to sulten_reservation_failure_day_path
      return
    end

    # In closed period
    Sulten::ClosedPeriod.current_and_future_closed_times.each do |period|
      if (period.closed_from..(period.closed_to + 1.day)).cover? to
        redirect_to sulten_reservation_failure_path
        return
      end
    end

    # Find tables
    tables = Sulten::Reservation.find_tables(from, to, people, type)
    if tables.count == 0
      redirect_to sulten_reservation_failure_path
      return
    end

    # Create reservation(s)
    reservation_entries = []
    Sulten::Reservation.transaction do
      # Save one reservation per table (uses duplicates)
      # Future improvement should be that reservations have multiple
      # tables instead, so the reservations are linked
      first = nil
      tables.each do |t|
        res = Sulten::Reservation.new(params)
        res.table = t
        # Copies have zero people
        if first == nil
          first = res
        else
          res.people = 0
        end
        reservation_entries << res
        res.save!
      end
      if first != nil
        SultenNotificationMailer.send_reservation_email(first).deliver
      end
    rescue
      reservation_entries.each do |r|
        r.destroy!
      end
      # Failed to save reservations
      redirect_to sulten_reservation_failure_path
      return
    end

    redirect_to sulten_reservation_success_path
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
      redirect_to sulten_admin_path
    else
      flash.now[:error] = t('helpers.models.sulten.reservation.errors.creation_fail')
      render :admin_new
    end
  end

  def show
    @reservation = Sulten::Reservation.find(params[:id])
  end

  def edit
    @reservation = Sulten::Reservation.find(params[:id])
  end

  def update
    @reservation = Sulten::Reservation.find params[:id]

    if @reservation.update(reservation_params)
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

  def success
  end

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
