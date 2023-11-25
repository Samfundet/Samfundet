after :generate_roles do
  def distinct_emails(how_many)
    emails = Set.new
    emails << Faker::Internet.email while emails.count < how_many
    emails.to_a
  end

  def phone_number
    (10000000 + rand * 9000000).to_i.to_s
  end

  number_of_applicants = 100
  accept_percent_chance = 30
  number_of_job_applications_pr_applicant = 3

  # Create campuses
  number_of_campuses = 10

  number_of_campuses.times do
    campus_name = Faker::Company.name
    puts "Creating campus #{campus_name}"
    Campus.create(name: campus_name)
  end

  # Seed member
  seed_member = Member.create(
    fornavn: "Seed",
    etternavn: "Boi 64",
    mail: "xXseedboy64Xx@yahoo.no",
    telefon: "64646464",
    passord: "seedboy"
  )

  # Create a number of applicants
  accepted_log = LogEntry.acceptance_log_entry

  puts "Creating #{number_of_applicants} applicants, and makes them apply for #{number_of_job_applications_pr_applicant} jobs, and accepting ~#{accept_percent_chance}%"
  distinct_emails(number_of_applicants).each do |email|
    applicant = Applicant.create!(
      firstname: Faker::Name.first_name,
      surname: Faker::Name.last_name,
      phone: phone_number,
      email: email,
      email_confirmation: email,
      campus: Campus.order(Arel.sql('random()')).first,
      password: 'passord',
      password_confirmation: 'passord',
      interested_other_positions: Faker::Boolean.boolean
    )

    # Apply jobs
    # puts "New applicant: #{applicant.full_name}"

    Admission.all.each do |admission|
      jobs = admission.jobs.all.sample(number_of_job_applications_pr_applicant)
      applications = []
      jobs.each_with_index do |job, priority|
        job_application = JobApplication.new(
          motivation: Faker::Lorem.paragraphs(number:5).join("\n\n"),
          applicant: applicant,
          priority: priority + 1,
          job: job
        )
        job_application.created_at = Faker::Time.between(from: 1.week.ago, to: 2.weeks.from_now)
        job_application.save
        Interview.create!(
            time: Faker::Time.between(from: 1.weeks.from_now, to: 2.weeks.from_now),
            priority: Interview::PRIORITIES_NO.keys.sample,
            job_application_id: job_application.id,
            location: Faker::Address.city
        )
        applications << job_application

        if rand(100) < accept_percent_chance
          job_number = rand(jobs.count)
          # @log_entry = LogEntry.create!(
          #   log: accepted_log,
          #   admission: admission,
          #   applicant: applicant,
          #   group: job.group,
          #   member: seed_member
          # )
        end
      end
    end
  end


  puts "Accepted #{LogEntry.where(admission: Admission.last).count} applicants total for last admission"
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
