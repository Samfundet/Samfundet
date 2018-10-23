# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Given /^I am registered with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  step %(there is an applicant with email "#{email}" and password "#{password}")
end

Given /^there is an applicant with email "([^\"]*)"$/ do |email|
  step "there is an applicant with email \"#{email}\" and password \"dummy password\""
end

Given /^there is an applicant with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  create_applicant(email: email, password: password)
end

Given /^(\d+) applicants exists?$/ do |number_of_applicants|
  number_of_applicants.to_i.times do |num|
    create_applicant(
      email: "user#{num}@domain.com",
      password: "password",
      firstname: "John",
      surname: "Doe #{num.ordinalize}"
    )
  end
end

Given /^I am logged in as an applicant with email "([^\"]*)"$/ do |email|
  step "I am registered with email \"#{email}\" and password \"secret\""

  visit applicants_login_path
  fill_in "applicant_login_email", with: email
  fill_in "applicant_login_password", with: "secret"
  click_button("Login as applicant")
end

When /^I log in as an applicant with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  # assumes you are on the login page
  fill_in "applicant_login_email", with: email
  fill_in "applicant_login_password", with: password
  click_button("Login as applicant")
end

Then /^the applicant email field should contain "([^"]+)"$/ do |email|
  page.should have_css("#applicant_login_email[value='#{email}']")
end
