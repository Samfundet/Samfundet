# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Given /^there is a member with first name "([^\"]*)"$/ do |first_name|
  without_access_control do
    Member.create!(
      fornavn: first_name,
      etternavn: "Doe",
      mail: "john@doe.com",
      passord: "passord",
      telefon: "12 34 56 78"
    )
  end
end

Given /^there is a member with email "([^\"]*)"$/ do |email|
  step "there is a member with email \"#{email}\" and password \"dummy password\""
end

Given /^there is a member with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  without_access_control do
    Member.create!(
      fornavn: "John",
      etternavn: "Doe",
      mail: email,
      telefon: "12 34 56 78",
      passord: password
    )
  end
end

Given /^there is a member with first name "([^\"]*)", email "([^\"]*)" and password "([^\"]*)"$/ do |first_name, email, password|
  without_access_control do
    Member.create!(
      fornavn: first_name,
      etternavn: "Doe",
      mail: email,
      telefon: "12 34 56 78",
      passord: password
    )
  end
end

Given /^I am logged in as a member with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  visit login_path
  fill_in "member_login_id", with: email
  fill_in "member_password", with: password
  click_button("member_login")
end

Given /^I am logged in as a member$/ do
  step "I am logged in as a member with email \"dummy@gmail.com\" and password \"dummy password\""
end

Then /^(?:|I )should be required to log in$/ do
  step "I should see \"You have to log in to view this page\""
end

Given /^I am logged in as an user with username "([^\"]*)"$/ do |username|
  step "I am registered with username \"#{username}\" and password \"secret\""

  visit login_path
  fill_in "username", with: username
  fill_in "password", with: "secret"
  click_button("Log in")
end

Given /^there is a user with email "([^\"]*)" and password "([^\"]*)"$/ do |email, password|
  without_access_control do
    Member.create!(
      fornavn: "John",
      etternavn: "Doe",
      mail: email,
      telefon: "12 34 56 78",
      passord: password
    )
  end
end

Given /^I am not logged in$/ do
  post logout_path
end

When /^I log in as a member with email "([^\"]*)" and password "([^\"]*)"/ do |email, password|
  # assumes you are on the login page
  fill_in "member_login_id", with: email
  fill_in "member_password", with: password
  click_button("Login as member")
end
