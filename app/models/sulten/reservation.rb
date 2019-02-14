# frozen_string_literal: true

class Sulten::Reservation < ApplicationRecord
  belongs_to :table
  belongs_to :reservation_type

  # attr_accessible :reservation_from, :reservation_duration, :reservation_to, :people, :name,
  #                :telephone, :email, :allergies, :internal_comment, :table_id, :reservation_type_id, :reservation_duration
  validates :reservation_from, :reservation_to, :people,
            :name, :telephone, :email, :reservation_type, presence: true

  attr_accessor :admin_access, :gdpr_checkbox

  validates :gdpr_checkbox, acceptance: true

  validate :check_opening_hours, :check_amount_of_people,
           :reservation_is_one_day_in_future, :email, on: :create, unless: :admin_access

  validates :email, email: true

  before_validation(on: :create) do
    unless [30, 60, 90, 120, 180].include? reservation_duration.to_i
      errors.add(:reservation_duration, I18n.t('helpers.models.sulten.reservation.errors.check_reservation_duration'))
      throw(:abort)
    end

    if reservation_from.nil?
      errors.add(:reservation_from, I18n.t('helpers.models.sulten.reservation.errors.invalid_reservation_format'))
      throw(:abort)
    end

    self.reservation_to = reservation_from + reservation_duration.to_i.minutes
  end

  before_validation(on: :update) do
    self.reservation_to = reservation_from + reservation_duration.to_i.minutes
  end

  after_validation(on: :create, unless: :admin_access) do
    self.table = Sulten::Reservation.find_table(reservation_from, reservation_to, people, reservation_type_id)

    unless table
      errors.add(:reservation_from,
                 I18n.t('helpers.models.sulten.reservation.errors.reservation_from.no_table_available'))
    end
  end

  def reservation_is_one_day_in_future
    if reservation_from < Date.tomorrow
      errors.add(:reservation_from, I18n.t('helpers.models.sulten.reservation.errors.reservation_from.reservation_is_one_day_in_future'))
    end
  end

  def check_opening_hours
    unless Sulten::Reservation.lyche_open?(reservation_from, reservation_to)
      errors.add(:reservation_from, I18n.t('helpers.models.sulten.reservation.errors.reservation_from.check_opening_hours'))
    end
  end

  def check_amount_of_people
    if people > 12
      errors.add(:people, I18n.t('helpers.models.sulten.reservation.errors.people.too_many_people'))
    elsif people < 1
      errors.add(:people, I18n.t('helpers.models.sulten.reservation.errors.people.too_few_people'))
    end
  end

  def first_name
    name.partition(' ').first
  end

  def reservation_duration=(duration)
    self.reservation_to = reservation_from + duration.to_i.minutes if reservation_from.present?
  end

  def reservation_duration
    @reservation_duration ||= ((reservation_to - reservation_from) / 60).to_i unless reservation_to.nil? || reservation_from.nil?
  end

  def self.find_table(from, to, people, reservation_type_id)
    (1..Sulten::ReservationType.count).each do |i|
      Sulten::Table.where('capacity >= ? and available = ?', people, true).order('capacity ASC').tables_with_i_reservation_types(i).find do |t|
        next unless t.reservation_types.pluck(:id).include? reservation_type_id
        if t.reservations.where('reservation_from > ? or reservation_to < ?', to, from).count == t.reservations.count
          return t
        end
      end
    end
    nil
  end

  def self.find_available_times(date, duration, people, type_id)
    now = Time.parse(date).utc
    default_open = now.change(hour: 16, min: 0, sec: 0)
    default_close = now.change(hour: 22, min: 0, sec: 0)
    possible_times = []
    time_frame = default_open.to_i..default_close.to_i
    times_to_check = time_frame.step(30.minutes).to_a
    Sulten::ReservationType.each do
      Sulten::Table.where('capacity >= ? and available = ?', people, true).order('capacity ASC').tables_with_i_reservation_types(i).find do |t|
        next unless t.reservation_types.pluck(:id).include? type_id
        time_frame.step(30.minutes) do |time_step|
          return possible_times if times_to_check.empty?
          next if times_to_check.exclude? time_step
          reservation_from = Time.zone.at(time_step)
          reservation_to = Time.zone.at(time_step + duration.minutes)

          busy_start = t.reservations.where('reservation_from >= ? and reservation_from < ?',
                                            reservation_from,
                                            reservation_to).any?

          busy_end = t.reservations.where('reservation_to > ? and reservation_to < ?',
                                          reservation_from,
                                          reservation_to).any?

          busy_table = busy_start || busy_end
          unless busy_table
            possible_times.push(reservation_from.utc)
            times_to_check.delete(time_step)
          end
        end
      end
    end
    possible_times
  end

  def is_in_closed_period?
    # This should only be validated when a reservation is created through the normal form
    Sulten::ClosedPeriod.current_and_future_closed_times.each do |period|
      if (period.closed_from..period.closed_to).cover? reservation_to
        false
      end
    end
    true
  end

  def self.lyche_open?(from, to)
    # TODO: Change these defaults when admin can set them
    # The values 16 .. 22 are the openinghours
    (from.hour >= 16 && to.hour < 22)
  end

  def self.kitchen_open?(from, to)
    (from.hour >= 16 && to.hour < 22)
  end
end
