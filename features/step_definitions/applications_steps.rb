# -*- encoding : utf-8 -*-
Given /^I have applied for jobs titled (.+)$/ do |jobs|
  step "There are jobs titled #{jobs}"

  jobs.split(", ").each do |job|
    visit admissions_path
    click_link job.strip.gsub(/[\"]/, '')
    fill_in "motivation", with: "I really want this job"
    click_button "Apply for this job"
  end
end

Then /^I should see the following:$/ do |expected_table|
  rows = find('table tbody').all('tr')
  table = rows.map { |r| r.all('th,td').map { |c| c.text.strip } }
  expected_table.diff!(table)
end

When /^I press "(.+)" in the (first|last) row$/ do |link_text, first_or_last|
 within("table tbody tr:#{first_or_last}-child") do
   click_button link_text
 end
end

Given /^my group, "([^\"]*)", has the following jobs: "(.*)"$/ do |group_name, job_titles|
  without_access_control do
    group = Group.create!(name: group_name,
                          abbreviation: group_name,
                          group_type: GroupType.create!(description: "Gruppetype", priority: 1))

    job_titles.split(", ").each do |job_title|
      Job.create!(title_no: job_title,
                  teaser_no: "tease",
                  description_no: "description",
                  is_officer: true,
                  group: group,
                  admission: Admission.first)
    end
  end
end

Given /^the groups (.+) have listed jobs$/ do |groups|
  step 'there are open admissions titled "Høstopptak 2010"'

  without_access_control do
    groups.split(", ").each do |name|
      group = Group.create!(
        name: name,
        abbreviation: name,
        group_type: GroupType.find_or_create_by_description("Drift")
      )
      group.jobs.create!(title_no: "A job", teaser_no: "A teaser", description_no: "A description", admission: Admission.first)
    end
  end
end

Given /^"([^\"]*)" has applied for "([^\"]*)" in "([^\"]*)" with phone number "([^\"]+)" and e\-mail "([^\"]+)"$/ do |name, job_title, group_name, phone, email|
  without_access_control do
    applicant = create_applicant(firstname: name.split(" ")[0],
                                 surname: name.split(" ")[1],
                                 email: email,
                                 phone: phone)

    job = Admission.first.jobs.find_by_title_no(job_title)
    JobApplication.create!(applicant: applicant, job: job, motivation: "I want it!!!")
  end
end

Then /^I should see "([^\"]*)" within the job titled "([^\"]*)"$/ do |name, job_title|
  within("ul.jobs") do
    Then "I should see \"#{name}\""
  end
end

# Then /^I should see  in each job$/ do
#   within "ul.jobs li.job" do
#     Then 'I should see "John Doe"'
#   end
# end
#
# Given /^"([^\" ]+) ([^\"]+)" has registered with phone number "(\d+)" and e\-mail "([^\"]*)"$/ do |firstname, surname, phone, email|
#   a = Applicant.find_by_firstname_and_surname(firstname, surname)
#   a.email = email
#   a.phone = phone
#   a.save!
#   # a = Applicant.create!(email: email, phone: phone, password: "passord",
#   #                   firstname: firstname, surname: lastname)
# end
