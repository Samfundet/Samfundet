after :organizers do
  admission_title = "Høstopptak 2010"

  puts "Creating admissions"
  old_admission_1 = Admission.create!(
      title: "Høstopptak 1917",
      shown_from: 100.years.ago - 2.weeks,
      shown_application_deadline: 100.years.ago,
      actual_application_deadline: 100.years.ago + 4.hours,
      user_priority_deadline: 100.years.ago + 1.week,
      admin_priority_deadline: 100.years.ago + 1.week + 1.hour,
      promo_video: "https://www.youtube.com/embed/T8MjwROd0dc"
  )
  old_admission_2 = Admission.create!(
      title: "Våropptak 1985",
      shown_from: 34.years.ago - 2.weeks,
      shown_application_deadline: 34.years.ago,
      actual_application_deadline: 34.years.ago + 4.hours,
      user_priority_deadline: 34.years.ago + 1.week,
      admin_priority_deadline: 34.years.ago + 1.week + 1.hour,
      promo_video: "https://www.youtube.com/embed/T8MjwROd0dc"
  )
  admission = Admission.create!(
    title: admission_title,
    shown_from: 1.week.ago,
    shown_application_deadline: 2.weeks.from_now,
    actual_application_deadline: 2.weeks.from_now + 4.hours,
    user_priority_deadline: 3.weeks.from_now,
    admin_priority_deadline: 3.weeks.from_now + 1.hour,
    promo_video: "https://www.youtube.com/embed/T8MjwROd0dc"
  )
  puts "Done creating admission"
  # TOOD: Create extraordinary admission

  # Create jobs and job descriptions
  possible_number_of_jobs_in_group = [1, 2, 3]
  puts "Creating jobs"

  Admission.all.each do |a|
    Group.all.each do |group|
      number_of_jobs = possible_number_of_jobs_in_group.sample
      puts number_of_jobs.to_s + " jobs to be created for #{group.short_name}"
      number_of_jobs.times do |n|
        group.jobs.create!(
          admission: a,
          title_no: Faker::Company.catch_phrase,
          teaser_no: Faker::Lorem.sentence(1),
          description_no: "En fantastisk stilling du bare MÅ søke. " + ("lorem ipsum boller og brus" * 30),
          is_officer: (rand > 0.5)
        )
      end
    end
  end
  puts "Done with creating jobs"
end
