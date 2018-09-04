# frozen_string_literal: true

namespace :sulten do
  desc 'This task removes all data from the database that can be associated with a sulten reservation'
  task anonymize: :environment do
    puts 'Anonymize sulten reservations'
    Sulten::Reservation.where('reservation_to < ?', Date.today).each do |reservation|
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
end
