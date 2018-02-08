# frozen_string_literal: true

class Campus < ApplicationRecord
  has_many :applicants

  def to_s
    name
  end

  def number_of_applicants
    applicants.count
  end

  def self.number_of_applicants_given_admission(admission)
    # Find all job applications of the current admission, get the unique user_id and group by campus_id.
    current = admission
    if current.nil?
      0
    else
      applicant_ids = current.job_applications.pluck(:applicant_id)
      campus_count = {}
      Applicant.where(id: applicant_ids).pluck(:campus_id).group_by { |i| i }.each { |k, v| campus_count[k] = v.length }
      campus_count.default = 0
      campus_count
    end
  end

  def self.number_of_applicants_current_admission
    # Find all job applications of the current admission, get the unique user_id and group by campus_id.
    current = Admission.current
    if current.nil?
      0
    else
      applicant_ids = current.first.job_applications.pluck(:applicant_id)
      campus_count = {}
      Applicant.where(id: applicant_ids).pluck(:campus_id).group_by { |i| i }.each { |k, v| campus_count[k] = v.length }
      campus_count.default = 0
      campus_count
    end
  end
end
