# frozen_string_literal: true

namespace :lyche do
  desc 'This task removes all data from the databse that can be associated with a lyche reservation'
  task anonymize: :environment do
    puts 'Anonymize lyche reservations'
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
