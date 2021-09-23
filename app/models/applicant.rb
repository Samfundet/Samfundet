# frozen_string_literal: true

class Applicant < ApplicationRecord
  has_many :job_applications, -> { order(:priority) }, dependent: :destroy
  has_many :jobs, through: :job_applications
  has_many :password_recoveries
  has_many :log_entries
  has_many :unavailable_interview_time_slots
  belongs_to :campus

  attr_accessor :password, :password_confirmation, :old_password, :gdpr_checkbox

  validates :firstname, :surname, :email, :phone, :campus, presence: true
  validates :email, :phone, uniqueness: true

  validates :email, email: true

  validates :gdpr_checkbox, acceptance: true

  validates :password, :password_confirmation,
            presence: { if: ->(applicant) { applicant.new_record? } }
  validates :password, length: { minimum: 6,
                                 if: ->(applicant) { applicant.new_record? } }
  validates :password, length: { minimum: 6, if: :password_changed? }
  validates :password, confirmation: { if: :password_changed? }
  validates :phone, format: { with: /\A[\d\s+]+\z/ }

  before_save :hash_new_password, if: :password_changed?

  def is_applicant
    true
  end

  def full_name
    "#{firstname} #{surname}"
  end

  def password_changed?
    !@password.nil?
  end

  def hash_new_password
    cost = if Rails.env == 'production'
             10
           else
             1
           end
    self.hashed_password = BCrypt::Password.create(@password, cost: cost)
  end

  def get_impossible_interview_times
    get_unavailable_interview_times + get_assigned_interview_times
  end

  def get_unavailable_interview_times
    unavailable_interview_time_slots = UnavailableInterviewTimeSlot.where(applicant_id: id, admission_id: $admission_id)

    unavailable_times = []
    unavailable_interview_time_slots.each do |t|
      unavailable_times.push(t.start_time.to_s)
      current_time = t.start_time
      while current_time < t.end_time
        current_time = current_time + 1.minutes
        unavailable_times.push(current_time.to_s)
      end
    end

    unavailable_times
  end

  def get_assigned_interview_times
    @job_applications = JobApplication.where(applicant_id: id)

    interview_times = []
    @job_applications.each do |j|
      if j.job.admission_id == $admission_id
        interval = j.job.interview_interval
        time = j.interview.time

        if time
          range = interval - 1
          start_time = time - range.minutes
          count = 2*interval - 1

          count.times do |x|
            interview_times.push((start_time + x.minutes).to_s)
          end
        end
      end
    end

    interview_times
  end

  def link_interviews(interview, group)
    jobs = [interview.job_application.job.title_no]
    @job_applications = JobApplication.where(applicant_id: id)
    @job_applications_without_interviews = @job_applications - @job_applications.select { |j| j.interview&.time }
    @job_applications_without_interviews.each do |j|
      if j.interview and j.job.linkable_interviews == true and j.job.group == group
        new_interview = j.find_or_create_interview
        new_interview.time = interview.time
        new_interview.location = interview.location
        new_interview.interview_time_slot_id = interview.interview_time_slot_id
        new_interview.save!
        jobs.push(j.job.title_no)
      end
    end

    jobs
  end

  def assigned_job_application(admission, priority: %w[wanted reserved])
    job_applications.where(withdrawn: false)
                    .joins(:interview)
                    .where(interviews: { priority: priority })
                    .find { |application| application.job.admission == admission }
  end

  def similar_jobs_not_applied_to
    similar_jobs = Set.new jobs.map(&:similar_available_jobs).flatten
    similar_jobs - jobs
  end

  def can_recover_password?
    password_recoveries.where('created_at > ?', Time.current - 1.day).count < 5
  end

  def create_recovery_hash
    Digest::SHA256.hexdigest(hashed_password + email + Time.current.to_s)
  end

  def check_hash(hash)
    password_recoveries.each do |recovery_hash|
      return true if hash == recovery_hash.recovery_hash && recovery_hash.created_at + 1.hour > Time.current
    end
    false
  end

  def self.interested_other_positions(admission)
    where(disabled: false).where(interested_other_positions: true).select do |applicant|
      # If not wanted by any
      applicant.assigned_job_application(admission, priority: %w[wanted]).nil? && !applicant.jobs_applied_to(admission).empty?
    end
  end

  def self.unflagged_applicants(admission)
    where(disabled: false).select do |applicant|
      # If not wanted by any
      !applicant.flagged?(admission) ||  applicant.reserved?(admission)
    end
  end

  class << self
    def authenticate(email, password)
      applicant = where(disabled: false).find_by(email: email.downcase)
      return applicant if applicant &&
                          BCrypt::Password.new(applicant.hashed_password) == password
    end
  end

  def lowest_priority_group(admission)
    job_applications.select { |application| application.job.admission == admission && application.withdrawn == false }.max_by(&:priority).job.group.id
  end

  def unwanted?(admission)
    assigned_job_application(admission, priority: ['wanted', 'reserved', '']).nil?
  end

  def flagged?(admission)
    assigned_job_application(admission, priority: ['', nil]).nil?
  end

  def reserved?(admission)
    !assigned_job_application(admission, priority: 'reserved').nil?
  end

  def jobs_applied_to(admission)
    job_applications.select { |application| application.job.admission == admission }.map(&:job)
  end

  def job_applications_at_group(admission, group)
    group.job_applications_in_admission(admission).select { |ja| ja.applicant == self }
  end

  def job_application_for_job(job)
    job_applications.find_by(job: job)
  end

  def has_interview_for_job(job)
    job_application_for_job(job).interview.time?
  end

  def lowercase_email
    self.email = email.downcase unless email.nil?
  end
end

# == Schema Information
#
# Table name: applicants
#
#  id                         :bigint           not null, primary key
#  firstname                  :string
#  surname                    :string
#  email                      :string
#  hashed_password            :string
#  phone                      :string
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  interested_other_positions :boolean
#  disabled                   :boolean          default(FALSE)
#  campus_id                  :integer
#
