# frozen_string_literal: true

class Sulten::AdminController < Sulten::BaseController
  # Custom authorization functionality because there is no associated resource with the controller
  before_action :authorize
  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, Sulten::Reservation }

  def index
    if params[:date] != nil
      @calendar_date = Date.strptime(params[:date], '%d-%m-%Y')
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
      @render_reservations[res.table_id] = []
    end

    @reservations_today.each do |res|
      offset_percent = ((res.reservation_from - start_timeline).seconds / length_timeline).to_f * 100
      width_percent = ((res.reservation_duration * 60) / length_timeline.to_f) * 100
      data = [res, offset_percent+0.5, width_percent-0.5, offset_percent < 50 ? true : false]
      @render_reservations[res.table_id].insert(0, data)
    end

    @total_reservations = @reservations.length
    @total_people = @reservations.map(&:people).sum
    @reservations = @reservations.sort_by(&:reservation_from).group_by { |i| i.reservation_from.to_date }
  end

  def admin_applet; end

private

  def authorize
    # Every action in this controller requires :manage permission on Sulten::Reservation
    authorize! :manage, Sulten::Reservation
  end
end
