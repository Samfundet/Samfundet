# -*- encoding : utf-8 -*-
class JobApplication < ActiveRecord::Base
  belongs_to :applicant
  belongs_to :job

  acts_as_list column: :priority

  has_one :interview, dependent: :destroy

  validates_presence_of :job, :motivation
  validates_presence_of :applicant, if: :validate_applicant?
  validates_uniqueness_of :applicant_id, scope: :job_id, message: I18n.t('jobs.already_applied')

  delegate :title, to: :job

  # named_scope :with_interviews, { conditions: ['interview.time > 0'] }

  def find_or_create_interview
    interview || create_interview
  end

  def assignment_status
    assigned_job_application = applicant.assigned_job_application(job.admission)
    if withdrawn
      return :withdrawn
    elsif assigned_job_application.nil?
      return :no_job
    else
      acceptance_status = assigned_job_application.find_or_create_interview.acceptance_status
      if assigned_job_application.job == job
        return acceptance_status == :reserved ? :this_job_reserved : :this_job
      else
        return acceptance_status == :reserved ? :other_job_reserved : :other_job
      end
    end
  end

  def validate_applicant?
    !@skip_applicant_validation
  end

  def skip_applicant_validation!
    @skip_applicant_validation = true
  end

  def last_log_entry
    LogEntry.where(
      admission_id: job.admission.id,
      applicant_id: applicant.id).last
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: job_applications
#
#  id           :integer          not null, primary key
#  motivation   :text
#  priority     :integer
#  applicant_id :integer
#  job_id       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
