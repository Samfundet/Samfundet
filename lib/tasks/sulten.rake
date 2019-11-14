# frozen_string_literal: true

namespace :sulten do
  desc 'This task removes all data from the database that can be associated with a sulten reservation'
  task anonymize: :environment do
    puts 'Anonymize sulten reservations'
    Sulten::Reservation.where('reservation_to < ?', Time.zone.today).each do |reservation|
      reservation.assign_attributes(
        name: Faker::Name.first_name,
        email: Faker::Internet.email,
        telephone: Faker::Base.numerify('########'),
        allergies: 'REDACTED'
      )
      reservation.save(validate: false)
      print '-'
    end
  end
  desc 'Seeds the sulten db with reservations today'
  task seed: :environment do
    puts 'Seeding reservations for today'

    Sulten::Reservation.delete_all
    tables = Sulten::Table.all
    types = Sulten::ReservationType.all

    # Create additional tables if necessary
    if tables.length < 30
      n_tables = 30-tables.length
      puts "Too few tables, creating " + n_tables.to_s + " more"
      (0..n_tables).each do |offset|
        if offset > 5
          table = Sulten::Table.create(number: tables.length + offset, capacity: rand(2..8), available: true)
        else
          table = Sulten::Table.create(number: 10 + tables.length + offset, capacity: rand(2..8), available: true)
        end
        table.reservation_types << types.sample(1)
      end
      tables = Sulten::Table.all
    end



    (0..5).each do |offset|
      20.times.each do
        now = DateTime.now + offset.days

        table_id = tables.sample(1)[0].id
        date = now.beginning_of_day + rand(15..23).hours + (rand(0..3)*15).minutes
        duration = rand(1..3)*30

        col_a = Sulten::Reservation.where(reservation_from: date..date+duration.minutes)
        col_b = Sulten::Reservation.where(reservation_to: date..date+duration.minutes)

        has_collision = false
        col_a.each do |res|
          if res.table_id == table_id
            has_collision = true
            break
          end
        end
        col_b.each do |res|
          if has_collision or res.table_id == table_id
            has_collision = true
            break
          end
        end

        unless has_collision
          Sulten::Reservation.new(
              name: Faker::Name.first_name,
              people: rand(2..4),
              reservation_from: date,
              email: Faker::Internet.email,
              reservation_duration: duration,
              telephone: "123456789",
              reservation_type_id: types.sample(1),
              table_id: tables.sample(1)[0].id,
              internal_comment: rand(0..5)==0 ? Faker::Lorem.sentence(12) : nil,
              allergies: rand(0..5)==0 ? Faker::Lorem.sentence(12) : nil
          ).save(validate: false)
        end
      end
    end
  end
end
