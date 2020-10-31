# frozen_string_literal: true

class JobApplication < ApplicationRecord
  belongs_to :applicant
  belongs_to :job

  acts_as_list column: :priority, scope: :applicant

  has_one :interview, dependent: :destroy

  validates :job, :motivation, presence: true
  validates :applicant, presence: { if: :validate_applicant? }
  validates :applicant_id, uniqueness: { scope: :job_id, message: I18n.t('jobs.already_applied') }

  delegate :title, to: :job

  # named_scope :with_interviews, { conditions: ['interview.time > 0'] }

  def find_or_create_interview
    interview || create_interview
  end

  def assignment_status
    assigned_job_application = applicant.assigned_job_application(job.admission)
    if withdrawn
      :withdrawn
    elsif assigned_job_application.nil?
      :no_job
    else
      priority = assigned_job_application.find_or_create_interview.priority
      if assigned_job_application.job == job
        priority == :reserved ? :this_job_reserved : :this_job
      else
        priority == :reserved ? :other_job_reserved : :other_job
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
      applicant_id: applicant.id
    ).last
  end
end

# == Schema Information
#
# Table name: job_applications
#
#  id           :bigint           not null, primary key
#  motivation   :text
#  priority     :integer
#  applicant_id :integer
#  job_id       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  withdrawn    :boolean          default(FALSE)
#
