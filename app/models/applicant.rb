# frozen_string_literal: true

class Applicant < ApplicationRecord
  has_many :job_applications, -> { order(:priority) }, dependent: :destroy
  has_many :jobs, through: :job_applications
  has_many :password_recoveries
  has_many :log_entries
  has_one :email_verification,
    class_name: 'EmailVerification',
    foreign_key: 'applicant_id'
  belongs_to :campus

  attr_accessor :email_confirmation, :password, :password_confirmation, :old_password, :gdpr_checkbox

  validates :firstname, :surname, :email, :phone, :campus, presence: true
  validates :email, :phone, uniqueness: true

  validates :email, :email_confirmation,
            presence: { if: ->(applicant) { applicant.new_record? } }
  validates :email, confirmation: { if: ->(applicant) { applicant.new_record? } }
  validates :email, format: { with: /\A.+@[a-z\d\-.]+\.[a-z]{2,}\z/i }

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

  def roles
    []
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

  def get_set_interviews(admission)
    @job_applications = open_job_applications(admission)
    interviews = []

    @job_applications.each do |j|
      if j.interview.time?
        interviews.push(j.interview)
      end
    end

    interviews
  end

  def set_interviews_string(admission)
    set_interviews = get_set_interviews(admission).length.to_s
    number_of_applications = jobs_applied_to(admission).length.to_s

    "#{set_interviews} av #{number_of_applications}"
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

  def create_email_verification_hash
    Digest::SHA256.hexdigest(email + Time.current.to_s + rand(1..100000).to_s)
  end

  def check_email_verification_hash(hash)
    if email_verification && email_verification.verification_hash == hash && email_verification.updated_at + 1.hour > Time.current
      email_verification.destroy!
      return true
    end
    false
  end

  def self.less_than_three_set_interviews(admission)
    where(disabled: false).select do |applicant|
      applicant.get_set_interviews(admission).length < 3 && applicant.open_job_applications(admission).length >= 3
    end
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
    def valid_email?(field)
      /\A.+@[a-z\d\-.]+\.[a-z]{2,}\z/i.match?(field)
    end

    def valid_phone?(field)
      /\A[\d\s+]+\z/.match?(field)
    end

    def authenticate(field, password)
      # Check if email or phone number
      if valid_email?(field)
        applicant = where(disabled: false).find_by(email: field.downcase)
      elsif valid_phone?(field)
        applicant = where(disabled: false).find_by(phone: field)
      end

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

  def priority_of_job_application(admission, job_application)
    job_applications.select { |application| application.job.admission == admission && application.withdrawn == false }.index(job_application) + 1
  end

  def priority_of_job_application_string(admission, job_application)
    priority = priority_of_job_application(admission, job_application).to_s
    number_of_applications = jobs_applied_to(admission).length.to_s

    "#{priority} av #{number_of_applications}"
  end

  def jobs_applied_to(admission)
    job_applications.select { |application| application.job.admission == admission }.map(&:job)
  end

  def open_job_applications(admission)
    job_applications.select { |application| application.job.admission == admission && application.withdrawn == false }
  end

  def open_job_applications_in_group(admission, group)
    job_applications.select { |ja| ja.job.admission == admission && ja.withdrawn == false && ja.job.group == group && ja.applicant == self }
  end

  def top_priority_job_application_at_group_without_interview(admission, group)
    job_applications.select { |application| application.job.admission == admission }.select { |ja| ja.job.group == group && !ja.interview.time?  && ja.withdrawn == false }.first
  end

private

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
