# -*- encoding : utf-8 -*-
# frozen_string_literal: true
Given /^there is a group named "([^\"]*)"$/ do |name|
  type = GroupType.create!(description: "Dummy group type")
  Group.create!(name: name, group_type: type)
end

Given /^the following groups exist: (.+)$/i do |groups|
  groups.split(", ").each do |name|
    group_name = name.strip.gsub(/[\"]/, '')
    step %(there is a group named "#{group_name}")
  end
end

Given /^there is a group type named "([^\"]*)"$/ do |name|
  GroupType.create!(description: name)
end

When /^(?:|I )post delete to the group page for "([^\"]*)"$/ do |name|
  visit path_to("the group page for \"#{name}\""), :delete
end
