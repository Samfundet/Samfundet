# frozen_string_literal: true

class RejectionEmail < ApplicationRecord
  belongs_to :admission
  belongs_to :applicant

  validates :admission, :applicant, :sent_at, presence: true

end

# == Schema Information
#
# Table name: rejection_emails
#
#  id                         :bigint           not null, primary key
#  admission_id               :integer
#  applicant_id               :integer
#
