# frozen_string_literal: true

class PasswordRecovery < ApplicationRecord
  # Dummy model to get on Rails good side.
  # Rails can suck my balls -Stian
end

# == Schema Information
#
# Table name: password_recoveries
#
#  id            :bigint           not null, primary key
#  recovery_hash :string
#  applicant_id  :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
