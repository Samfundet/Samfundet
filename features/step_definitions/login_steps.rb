# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Given /^I am a member in "([^\"]*)" with roles "([^\"]*)"$/ do |group, roles|
  without_access_control do
    # TODO: ALlow acces to RSpec helpers
    # ModelHelper.create_member does this shit..
    # Even better... User factorygirl and shit.
    step %(there is a member with email "valid@user.com" and password "password")

    member = Member.find_by(mail: 'valid@user.com')
    roles.split(", ").each do |role_name|
      role = Role.find_or_create_by_title(title: role_name.strip, name: "Dummy name", description: "Dummy description")
      member.roles << role
      member.save
    end

    step %(I am logged in as a member with email "valid@user.com" and password "password")
  end
end

Given /^I am logged in as an applicant$/ do
  step %(I am logged in as an applicant with email "soker@sokersen.no")
  Authorization.ignore_access_control(false)
end

Then /^I should see a notice about open admissions$/ do
  within("#admission-notice") do |content|
    content.should_not be_blank
  end
end

Then /^I should not see a notice about open admissions$/ do
  should_not have_selector("#admission-notice")
end

Then /^I should not be logged in$/ do
  page.should have_content("Log in")
end

Then /^I should be logged in$/ do
  page.should_not have_content("Log in")
end

Then /^I should be logged in as a member with email "([^\"]*)"$/ do |email|
  member = Member.find_by mail: email
  step %(I should be logged in as "#{member.full_name}")
end

Then /^I should be logged in as an applicant with email "([^\"]*)"$/ do |email|
  applicant = Applicant.find_by email: email
  step %(I should be logged in as "#{applicant.full_name}")
end

Then /^I should be logged in as "([^\"]*)"$/ do |name|
  step %(I should see "#{name}")
end
