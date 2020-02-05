after :generate_roles do
  def distinct_emails(how_many)
    emails = Set.new
    emails << Faker::Internet.email while emails.count < how_many
    emails.to_a
  end

  def phone_number
    (10000000 + rand * 9000000).to_i.to_s
  end

  number_of_applicants = 50
  number_of_job_applications_pr_applicant = 3

  # Create campuses
  number_of_campuses = 10

  number_of_campuses.times do
    campus_name = Faker::Company.name
    puts "Creating campus #{campus_name}"
    Campus.create(name: campus_name)
  end

  # Create a number of applicants
  puts "Creating #{number_of_applicants} applicants, and makes them apply for #{number_of_job_applications_pr_applicant} jobs"
  distinct_emails(number_of_applicants).each do |email|
    applicant = Applicant.create!(
      firstname: Faker::Name.first_name,
      surname: Faker::Name.last_name,
      phone: phone_number,
      email: email,
      campus: Campus.order(Arel.sql('random()')).first,
      password: 'passord',
      password_confirmation: 'passord',
      interested_other_positions: Faker::Boolean.boolean
    )

    # Apply jobs
    # puts "New applicant: #{applicant.full_name}"

    jobs = Job.all.sample(number_of_job_applications_pr_applicant)
    jobs.each_with_index do |job, priority|
      job_application = JobApplication.create!(
        motivation: Faker::Lorem.paragraphs(5).join("\n\n"),
        applicant: applicant,
        priority: priority + 1,
        job: job
      )
      Interview.create!(
        time: Faker::Time.between(1.weeks.from_now, 2.weeks.from_now),
        acceptance_status: Interview::ACCEPTANCE_STATUSES_NO.keys.sample,
        job_application_id: job_application.id,
        location: Faker::Address.city
      )
    end
  end
  puts "Done applying jobs"

  puts "Creating people who have each role in the system"

  roles = Role.all
  emails = distinct_emails(roles.count)

  roles.zip(emails) do |role, email|
    member = Member.create!(
      fornavn: Faker::Name.first_name,
      etternavn: role.title.camelize,
      mail: email,
      telefon: phone_number,
      passord: 'passord',
    )
    member.roles << role
  end
  puts 'Created members.'
end
