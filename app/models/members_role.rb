# -*- encoding : utf-8 -*-
class MembersRole < ActiveRecord::Base
  validates_presence_of :member_id
  validates_presence_of :role_id
  attr_accessible :created_at

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
