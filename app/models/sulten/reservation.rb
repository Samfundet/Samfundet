class Sulten::Reservation < ActiveRecord::Base
  belongs_to :table
  belongs_to :reservation_type

  attr_accessible :reservation_from, :reservation_duration, :reservation_to, :people, :name,
    :telephone, :email, :allergies, :internal_comment, :table_id, :reservation_type_id, :reservation_duration

  attr_accessor :reservation_duration

  validates_presence_of :reservation_from, :reservation_to, :reservation_duration, :people,
    :name, :telephone, :email, :reservation_type

  validate :check_opening_hours, :reservation_is_one_day_in_future, :check_amount_of_people, on: :create

  validate :email, email: true

  before_validation(on: :create) do
    should_break = false

    if not [30, 60, 90, 120].include? reservation_duration.to_i
      errors.add(:reservation_duration, I18n.t("helpers.models.sulten.reservation.errors.people.check_reservation_duration"))
      should_break = true
    end

    if reservation_from.nil?
      errors.add(:reservation_from, I18n.t("helpers.models.sulten.reservation.errors.invalid_reservation_format"))
      should_break = true
    end

    return false if should_break

    self.reservation_to = reservation_from + reservation_duration.to_i.minutes
  end

  after_validation(on: :create) do
    self.table = Sulten::Reservation.find_table(reservation_from, reservation_to, people, reservation_type_id)

    unless self.table
      errors.add(:reservation_from,
                 I18n.t("helpers.models.sulten.reservation.errors.reservation_from.no_table_available"))
    end
  end

  def reservation_is_one_day_in_future
    if reservation_from < Date.tomorrow
      errors.add(:reservation_from, I18n.t("helpers.models.sulten.reservation.errors.reservation_from.reservation_is_one_day_in_future"))
    end
  end

  def check_opening_hours
    if Sulten::ReservationType.find(reservation_type_id).needs_kitchen
      if not Sulten::Reservation.kitchen_open?(self.reservation_from, self.reservation_to)
        errors.add(:reservation_from, I18n.t("helpers.models.sulten.reservation.errors.reservation_from.check_kitchen_opening_hours"))
      end
    else
      if not Sulten::Reservation.lyche_open?(self.reservation_from, self.reservation_to)
        errors.add(:reservation_from, I18n.t("helpers.models.sulten.reservation.errors.reservation_from.check_lyche_opening_hours"))
      end
    end
  end

  def check_amount_of_people
    if people > 12
      errors.add(:people, I18n.t("helpers.models.sulten.reservation.errors.people.too_many_people"))
    elsif people < 1
      errors.add(:people, I18n.t("helpers.models.sulten.reservation.errors.people.too_few_people"))
    end
  end

  def first_name
    self.name.partition(" ").first
  end

  def self.find_table from, to, people, reservation_type_id
    for i in 1..Sulten::ReservationType.all.length
      Sulten::Table.where("capacity >= ? and available = ?", people, true).order("capacity ASC").tables_with_i_reservation_types(i).find do |t|
        if t.reservation_types.pluck(:id).include? reservation_type_id
          if t.reservations.where("reservation_from > ? or reservation_to < ?", to, from).count == t.reservations.count
            return t
          end
        end
      end
    end
    return nil
  end

  def self.lyche_open? from, to
    lycheOpen = Sulten::LycheOpeningHours.where(day_number: from.wday).pluck(:openLyche)[0]
    lycheClose = Sulten::LycheOpeningHours.where(day_number: from.wday).pluck(:closeLyche)[0]
    return (lycheOpen.strftime( "%H%M%S" )..lycheClose.strftime("%H%M%S")).include?(from.strftime( "%H%M%S" )..to.strftime( "%H%M%S" ))
  end

  def self.kitchen_open? from, to
    kitchenOpen = Sulten::LycheOpeningHours.where(day_number: from.wday).pluck(:openKitchen)[0]
    kitchenClose = Sulten::LycheOpeningHours.where(day_number: from.wday).pluck(:closeKitchen)[0]
    return (kitchenOpen.strftime( "%H%M%S" )..kitchenClose.strftime("%H%M%S")).include?(from.strftime( "%H%M%S" )..to.strftime( "%H%M%S" ))

  end
end
