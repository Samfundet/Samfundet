# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Given /^there are (open|closed) admissions titled (.+)$/i do |status, admissions|
  without_access_control do
    opts = case status
             when "open"
               {
                shown_from: Time.current,
                shown_application_deadline: 1.week.from_now,
                actual_application_deadline: 1.week.from_now + 4.hours,
                user_priority_deadline: 2.weeks.from_now,
                admin_priority_deadline: 2.weeks.from_now + 1.hour
               }
             when "closed"
               {
                shown_from: 5.weeks.ago,
                shown_application_deadline: 5.weeks.ago + 1.week,
                actual_application_deadline: 5.weeks.ago + 1.week + 4.hours,
                user_priority_deadline: 5.weeks.ago + 2.weeks,
                admin_priority_deadline: 5.weeks.ago + 2.weeks + 1.hour
               }
           end

    admissions.split(", ").each do |title|
      admission = Admission.create! opts.merge(title: title)
    end
  end

  #  When /^I delete the (\d+)(?:st|nd|rd|th) admission$/ do |pos|
  #  visit show_admissions_path
  #  within("table > tr:nth-child(#{pos.to_i+1})") do
  #    click_link "Destroy"
  #  end
end
