# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class PasswordRecovery < ActiveRecord::Base
  # Dummy model to get on Rails good side.
  # Rails can suck my balls -Stian
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: password_recoveries
#
#  id            :integer          not null, primary key
#  recovery_hash :string(255)
#  applicant_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
