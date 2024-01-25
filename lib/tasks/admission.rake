# frozen_string_literal: true

namespace :admission do
  desc 'This task removes all data from the database that can be associated with an applicant.'
  task anonymize: :environment do
    puts 'Anonymize applicants'
    Applicant.all.each do |applicant|
      password = Faker::Internet.password

      applicant.assign_attributes(
        firstname: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        phone: Faker::Base.numerify('########'),
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        disabled: true
      )

      applicant.save(validate: false)
      print '.'
    end

    puts "\nAnonymize interviews"
    Interview.all.each do |interview|
      interview.assign_attributes(comment: '', time: '01/Jan/2000 00:00:00 +0100', location: '')
      if interview.priority == :wanted and interview.applicant_status == :declined
        interview.priority = :not_wanted
        interview.applicant_status = :rejected
      end
      if interview.priority == :reserved
        if interview.applicant_status == :accepted
          interview.priority = :wanted
        else
          interview.priority = :not_wanted
        end
      end
      interview.save(validate: false)
      print '.'
    end

    puts "\nAnonymize JobApplication"
    JobApplication.all.each do |job_application|
      job_application.assign_attributes(motivation: '[REDACTED]')
      job_application.save(validate: false)
      print '.'
    end
  end
end
