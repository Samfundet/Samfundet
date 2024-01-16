# frozen_string_literal: true

class EmailVerification < ApplicationRecord
  # Dummy model to get db fetching to work
  belongs_to :applicant, class_name: 'Applicant'
end

# == Schema Information
#
# Table name: email_verifications
#
#  id                 :bigint           not null, primary key
#  verification_hash  :string           not null
#  count              :integer          not null, default: 1
#  applicant_id       :integer          not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
