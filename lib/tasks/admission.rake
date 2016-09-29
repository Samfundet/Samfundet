namespace :admission do
  desc "This task removes all data from the database that can be associated with an applicant."
  task anonymize: :environment do
    Applicant.where(disabled: false).each do |applicant|
      password = Faker::Internet.password

      applicant.assign_attributes(
        firstname: Faker::Name.first_name,
        surname: Faker::Name.last_name,
        phone: Faker::Base.numerify("########"),
        email: Faker::Internet.email,
        password: password,
        password_confirmation: password,
        disabled: true
      )

      applicant.save(validate: false)
    end

    Interview.all.each do |interview|
      interview.assign_attributes(comment: "")
      interview.save(validate: false)
    end

    JobApplication.all.each do |job_application|
      job_application.assign_attributes(motivation: "")
      job_application.save(validate: false)
    end
  end
end
