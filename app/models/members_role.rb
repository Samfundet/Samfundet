# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class MembersRole < ActiveRecord::Base
  validates :member_id, presence: true
  validates :role_id, presence: true

  belongs_to :member, touch: true
  belongs_to :role
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: members_roles
#
#  id        :integer          not null, primary key
#  member_id :integer
#  role_id   :integer
#
