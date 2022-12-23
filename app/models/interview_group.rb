# frozen_string_literal: true

class InterviewGroup < ApplicationRecord
  belongs_to :admission, touch: true
  belongs_to :group

  has_many :jobs

  validates :name, :description, presence: true

  def applicants_for_group
  end

  def set_interview_time(applicant)
  end
end
