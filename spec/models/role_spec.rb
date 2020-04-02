# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id                :bigint           not null, primary key
#  name              :string
#  title             :string
#  description       :text
#  show_in_hierarchy :boolean          default(FALSE)
#  role_id           :integer
#  group_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  passable          :boolean          default(FALSE)
#
require 'rails_helper'

describe Role do
  xit 'should create tests for this'
end
