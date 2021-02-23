# frozen_string_literal: true

class Sulten::Reservation < ApplicationRecord

  @@mutex = Mutex.new

  belongs_to :table
  belongs_to :reservation_type

  # attr_accessible :reservation_from, :reservation_duration, :reservation_to, :people, :name,
  #                :telephone, :email, :allergies, :internal_comment, :table_id, :reservation_type_id, :reservation_duration
  validates :reservation_from, :reservation_to, :people,
            :name, :telephone, :email, :reservation_type, presence: true

  attr_accessor :admin_access, :gdpr_checkbox

  validates :gdpr_checkbox, acceptance: true

  validate :check_opening_hours, :check_amount_of_people,
           :reservation_is_one_day_in_future,
           :email, on: :create, unless: :admin_access

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

  # If table was deleted, return a dummy table to prevent null-pointer exceptions
  def table
    super || Sulten::Table.new(number: -1, capacity: 0, available: false)
  end

  def missing_table
    table.number == -1
  end

  def reservation_is_one_day_in_future
    if reservation_from < Date.tomorrow
      errors.add(:reservation_from, I18n.t('helpers.models.sulten.reservation.errors.reservation_from.reservation_is_one_day_in_future'))
    end
  end

  def check_opening_hours
    unless Sulten::Reservation.lyche_open?(reservation_from, reservation_to - 1.minutes)
      errors.add(:reservation_from, I18n.t('helpers.models.sulten.reservation.errors.reservation_from.check_opening_hours'))
    end
  end

  def check_amount_of_people
    if people > 8
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

  # Finds available table(s) for a reservation
  # Single tables are prioritized by smallest capacity
  #   - For tables of same size, the one with fewest neighbours is preferred
  # Group tables are prioritized by smallest total capacity
  def self.find_tables(from, to, people, reservation_type_id)
    # Mutual exclusion
    mutex.lock

    table = nil

    # Find available single tables
    Sulten::Table.where('capacity >= ? and available = ?', people, true).each do |t|
      # Table does not support reservation type
      unless t.reservation_types.pluck(:id).include? reservation_type_id
        next
      end
      # Table is larger than one already found
      if not table.nil? and t.capacity > table.capacity
        next
      end
      # Table is same size but has more neighbours (prefer edge tables)
      if not table.nil? and t.capacity == table.capacity and t.neighbour_count > table.neighbour_count
        next
      end
      # Finally check if table is available (done last to reduce SQL fetches)
      # We add 30 minutes before and after the reservation because Lyche wants time between reservations to clean up!
      if t.reservations.where('reservation_from >= ? or reservation_to <= ?', to + 30.minutes, from - 30.minutes).count == t.reservations.count
        table = t
      end
    end

    # Found single table!
    unless table.nil?
      mutex.unlock
      return [table]
    end

    # First find all possible tables that can be part of a group
    available_group_tables = []
    Sulten::Table.where('available = ?', true).each do |t|
      # Table has no neighbours (and thus cannot be in a table group)
      if t.neighbour_count == 0
        next
      end
      # Table does not support reservation type
      unless t.reservation_types.pluck(:id).include? reservation_type_id
        next
      end
      # Table has a reservation already
      if t.reservations.where('reservation_from >= ? or reservation_to <= ?', to + 30.minutes, from - 30.minutes).count != t.reservations.count
        next
      end
      available_group_tables << t
    end

    # No groups possible
    if available_group_tables.size == 0
      mutex.unlock
      nil
    end

    # Find the best table group
    group = []
    group_capacity = 0

    available_group_tables.each do |t|
      # Fetch possible neighbour groups
      # NOTE: This function does not consider availability of tables
      groups = t.neighbour_groups

      groups.each do |g|
        # Check that all tables in group are in fact available group tables
        ok_tables = g.select { |x| available_group_tables.include? x }
        if ok_tables.size != g.size
          next
        end
        # Check that total capacity is sufficient
        capacity = g.inject(0) { |sum, x| sum + x.capacity }
        if capacity < people
          next
        end
        # If no group found yet or capacity lower (prefer smallest group)
        if group.empty? or capacity < group_capacity
          group = g
          group_capacity = capacity
        end
      end
    end

    mutex.unlock
    group
  end

  def self.check_if_time_is_valid(from, to, people, reservation_type_id)
    tbl = find_tables(from, to, people, reservation_type_id)
    if tbl.nil? or tbl == []
      nil
    else
      from
    end
  end

  def self.find_available_times(date, people, type_id)
    duration = 120
    now = Time.parse(date)
    reservation_open = now.change(hour: 16, min: 0, sec: 0)
    if (date.to_datetime).friday? or (date.to_datetime).saturday? or (date.to_datetime).sunday?
      reservation_close = now.change(hour: 20, min: 0, sec: 0)
    else
      reservation_close = now.change(hour: 21, min: 0, sec: 0)
    end
    possible_times = []
    time_frame = reservation_open.to_i..reservation_close.to_i
    times_to_check = time_frame.step(30.minutes).to_a
    time_frame.step(30.minutes) do |time_step|
      return possible_times if times_to_check.empty?
      next if times_to_check.exclude? time_step
      reservation_from = Time.zone.at(time_step)
      reservation_to = Time.zone.at(time_step + duration.minutes)
      t = check_if_time_is_valid(reservation_from, reservation_to, people, type_id)
      if t
        possible_times.insert(-1, t)
      end
    end
    possible_times
  end

  def in_closed_period?
    # This should only be validated when a reservation is created through the normal form
    Sulten::ClosedPeriod.current_and_future_closed_times.each do |period|
      if (period.closed_from..(period.closed_to + 1.day)).cover? reservation_to
        return true
      end
    end
    false
  end

  def self.lyche_open?(from, to)
    # TODO: Change these defaults when admin can set them
    # The values 16 .. 22 are the openinghours
    (from.hour >= 16 && to.hour < 23)
  end

  def self.kitchen_open?(from, to)
    (from.hour >= 16 && to.hour < 23)
  end
end

# == Schema Information
#
# Table name: sulten_reservations
#
#  id                  :bigint           not null, primary key
#  reservation_from    :datetime
#  people              :integer
#  table_id            :integer
#  reservation_type_id :integer
#  name                :string
#  telephone           :string
#  email               :string
#  allergies           :string
#  internal_comment    :string
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reservation_to      :datetime
#
