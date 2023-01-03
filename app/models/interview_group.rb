# frozen_string_literal: true

class InterviewGroup < ApplicationRecord
  belongs_to :admission, touch: true
  belongs_to :group

  has_many :jobs

  validates :name, :description, presence: true

  def has_job(job)
    jobs.include? job
  end

  def applicants_for_interview_group(applicant)
    group_applicants = group.applicants(admission)
    interview_group_applicants = []

    group_applicants.each do |applicant|
      applicant.jobs_applied_to(admission).each do |job|
        if jobs.include? job
          interview_group_applicants.push(applicant)
          break
        end
      end
    end

    interview_group_applicants
  end

  def set_interview(applicant, interview)
    applicant.job_applications_at_group(admission, group).each do |job_application|
      if jobs.include? job_application.job
        job_application.interview = interview
      end
    end
  end
end
