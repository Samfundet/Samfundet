# -*- encoding : utf-8 -*-
Given /^There are jobs titled (.+)$/i do |jobs|
  step "There are open admissions titled Sample Admission"

  without_access_control do
    group = Group.find_or_initialize_by_name("Layout Info Marked")
    if group.new_record?
      group.group_type = GroupType.find_or_create_by_description("Drift")
      group.save!
    end

    admission = Admission.find_by_title("Sample Admission")

    jobs.split(",").each do |title|
      Job.create!(
        admission: admission,
        title_no: title.strip.gsub(/[\"]/, ''),
        description_no: "This job is really cool.",
        teaser_no: "TEASE ME!",
        group: group)
    end
  end
end

Given /^there is a job titled "([^\"]*)" in the group "([^\"]*)" tagged "([^\"]*)"$/ do |job_title, group_name, tags|
  step "there are jobs \"#{job_title}\" for an admission \"Sample Admission\" for the group \"#{group_name}\""

  without_access_control do
    job = Job.find_by_title_no!(job_title)
    tags.split.each do |tag|
      job.tags << JobTag.find_or_create_by_title(tag)
    end
  end
end

Given /^"([^\"]*)" is an officer position$/ do |job_title|
  without_access_control do
    job = Job.find_by_title_no!(job_title)
    job.is_officer = true
    job.save!
  end
end


Given /^there are jobs (.+) for an admission "([^"]+)" for the group "([^"]+)"$/ do |jobs, admission_title, group_name|
  without_access_control do
    group = Group.find_or_initialize_by_name(group_name)
    if group.new_record?
      group.group_type = GroupType.create!(description: "Sirkus")
      group.save!
    end

    admission = Admission.create!(title: admission_title,
                                  shown_from: Time.current,
                                  shown_application_deadline: 1.week.from_now,
                                  actual_application_deadline: 1.week.from_now + 4.hours,
                                  user_priority_deadline: 2.weeks.from_now,
                                  admin_priority_deadline: 2.weeks.from_now + 1.hour)

    jobs.split(", ").each do |quoted_title|
      title = quoted_title.gsub(/"/, "")

      Job.create!(
        admission: admission,
        title_no: title,
        description_no: "Fancy description",
        teaser_no: "Fancier teaser",
        group: group)
    end
  end
end

Given /^the job "([^\"]*)" has tags (.+)$/ do |title, tags|
  without_access_control do
    job = Job.find_by_title_no(title)
    tags.split(",").each do |quoted_title|
      title = quoted_title.gsub(/\w*"\w*/, "")
      job.tags << JobTag.find_or_create_by_title(title)
    end
  end
end
