# frozen_string_literal: true

class Applicant < ActiveRecord::Base
  has_many :job_applications, -> { where(withdrawn: false).order(:priority) }, dependent: :destroy
  has_many :jobs, through: :job_applications
  has_many :password_recoveries
  has_many :log_entries
  belongs_to :campus

  attr_accessor :password, :password_confirmation, :old_password

  validates :firstname, :surname, :email, :phone, :campus_id, presence: true
  validates :email, :phone, uniqueness: true

  validates :email, email: true

  validates :password, :password_confirmation,
            presence: { if: ->(applicant) { applicant.new_record? } }
  validates :password, length: { minimum: 6,
                                 if: ->(applicant) { applicant.new_record? } }
  validates :password, length: { minimum: 6, if: :password_changed? }
  validates :password, confirmation: { if: :password_changed? }
  validates :phone, format: { with: /\A[\d\s+]+\z/ }

  before_save :hash_new_password, if: :password_changed?

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

  def assigned_job_application(admission, acceptance_status: %w[wanted reserved])
    job_applications.joins(:interview)
                    .where(interviews: { acceptance_status: acceptance_status })
                    .find { |application| application.job.admission == admission && application.withdrawn == false }
  end

  def similar_jobs_not_applied_to
    similar_jobs = Set.new jobs.map(&:similar_available_jobs).flatten
    similar_jobs - jobs
  end

  # Static because an applicant should be separated from the rest of the system
  def role_symbols
    # Think trice before changing this!
    [:soker]
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
      applicant.assigned_job_application(admission, acceptance_status: %w[wanted]).nil?
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
    assigned_job_application(admission, acceptance_status: ['wanted', 'reserved', '']).nil?
  end

  def jobs_applied_to(admission)
    job_applications.select { |application| application.job.admission == admission }.map(&:job)
  end

  def job_applications_at_group(admission, group)
    group.job_applications_in_admission(admission).select { |ja| ja.applicant == self }
  end

  private

  def lowercase_email
    self.email = email.downcase unless email.nil?
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: applicants
#
#  id              :integer          not null, primary key
#  firstname       :string(255)
#  surname         :string(255)
#  email           :string(255)
#  hashed_password :string(255)
#  phone           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
