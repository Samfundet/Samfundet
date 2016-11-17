# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Given /^the member "([^\"]*)" has the role of "([^\"]*)"$/ do |first_name, role|
  without_access_control do
    member = Member.find_by(fornavn: first_name)
    role = Role.find_or_create_by_title(
      title: role,
      name: "Dummy name",
      description: "Dummy description."
    )
    member.roles << role
  end
end

Given /^there is a role titled "([^\"]*)"$/ do |title|
  without_access_control do
    Role.find_or_create_by_title(
      title: title,
      name: "Dummy name",
      description: "Dummy description."
    )
  end
end

Given /^there is a role titled "([^\"]*)" and named "([^\"]*)"$/ do |title, name|
  without_access_control do
    Role.find_or_create_by_title(
      title: title,
      name: name,
      description: "Dummy description."
    )
  end
end

Given /^the following roles exist: (.+)$/i do |roles|
  roles.split(", ").each do |title|
    title = title.strip.gsub(/[\"]/, '')
    step %(there is a role titled "#{title}")
  end
end

Given /^we reload authorization settings$/ do
  Authorization::Engine.instance("config/authorization_rules.rb")
end
