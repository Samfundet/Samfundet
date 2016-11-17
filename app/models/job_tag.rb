# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class JobTag < ActiveRecord::Base
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: job_tags
#
#  id         :integer          not null, primary key
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
