# -*- encoding : utf-8 -*-
Given /^"([^"]*)" has applied for "([^"]+)" with motivation "([^"]+)"$/ do |applicant_name, job_name, motivation|
  first, second = applicant_name.split " "
  applicant = Applicant.find_or_initialize_by_firstname_and_surname(first, second)
  applicant.email = Faker::Internet.free_email
  applicant.phone = (10000000 + rand * 9000000).to_i.to_s
  applicant.password = "passord"
  applicant.password_confirmation = "passord"
  applicant.save!

  job = Job.find_by_title_no(job_name.strip.gsub(/[\"]/, ''))
  ja = JobApplication.new(job: job,
                          motivation: motivation,
                          priority: 1)
  ja.applicant = applicant
  ja.save
end

Given /^There are jobs for "([^"]*)" in "([^"]*)" titled (.+)$/i do |group_name, admission_title, job_titles|
  group = Group.find_or_initialize_by_name(group_name)
  if group.new_record?
    group.group_type = GroupType.create!(description: "Sirkus")
    group.save!
  end

  admission = Admission.find_by_title(admission_title)

  job_titles.split(/, ?/).each do |job_title|
    Job.create!(title_no: job_title.strip.gsub(/[\"]/, ''),
                teaser_no: "Dummy teaser",
                group: group,
                description_no: "Foo bar",
                admission: admission)
  end
end
