# frozen_string_literal: true
class Sulten::Reservation < ActiveRecord::Base
  belongs_to :table
  belongs_to :reservation_type

  validates :reservation_from, :reservation_to, :people,
            :name, :telephone, :email, :reservation_type, presence: true

  validate :check_opening_hours, :reservation_is_one_day_in_future, :check_amount_of_people, on: :create

  validates :email, email: true

  before_validation(on: :create) do
    unless [30, 60, 90, 120].include? reservation_duration.to_i
      errors.add(:reservation_duration, I18n.t('helpers.models.sulten.reservation.errors.check_reservation_duration'))
      throw(:abort)
    end

    if reservation_from.nil?
      errors.add(:reservation_from, I18n.t('helpers.models.sulten.reservation.errors.invalid_reservation_format'))
      throw(:abort)
    end
  end

  after_validation(on: :create) do
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
    for i in 1..Sulten::ReservationType.all.length
      Sulten::Table.where('capacity >= ? and available = ?', people, true).order('capacity ASC').tables_with_i_reservation_types(i).find do |t|
        next unless t.reservation_types.pluck(:id).include? reservation_type_id
        if t.reservations.where('reservation_from > ? or reservation_to < ?', to, from).count == t.reservations.count
          return t
        end
      end
    end
    nil
  end

  def self.lyche_open?(from, to)
    # TODO: Change these defaults when admin can set them
    # The values 16 .. 22 are the openinghours
    (16..22).cover?(from.hour..to.hour)
  end

  def self.kitchen_open?(from, to)
    default_kitchen_opening_hour = Time.new(2015, 0o1, 0o1, 16, 0o0, 0o0)
    default_kitchen_closing_hour = Time.new(2015, 0o1, 0o1, 22, 0o0, 0o0)
    (16..22).cover?(from.hour..to.hour)
  end
end
