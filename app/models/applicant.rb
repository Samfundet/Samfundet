# -*- encoding : utf-8 -*-

class Applicant < ActiveRecord::Base
  has_many :job_applications, order: 'priority', dependent: :destroy
  has_many :jobs, through: :job_applications
  has_many :password_recoveries
  has_many :log_entries

  attr_accessor :password, :password_confirmation, :old_password

  validates_presence_of :firstname, :surname, :email, :phone, :campus
  validates_uniqueness_of :email, :phone

  validates :email, email: true

  validates_presence_of :password, :password_confirmation,
                        if: ->(applicant) { applicant.new_record? }
  validates_length_of :password, minimum: 6,
                        if: ->(applicant) { applicant.new_record? }
  validates_length_of :password, minimum: 6, if: :password_changed?
  validates_confirmation_of :password, if: :password_changed?
  validates_format_of :phone, with: /^[\d\s+]+$/

  before_save :hash_new_password, if: :password_changed?

  def full_name
    "#{firstname} #{surname}"
  end

  def password_changed?
    !@password.nil?
  end

  def hash_new_password
    if Rails.env == "production"
      cost = 10
    else
      cost = 1
    end
    self.hashed_password = BCrypt::Password.create(@password, cost: cost)
  end

  def assigned_job_application(admission)
    job_applications.joins(:interview)
      .where(interviews: { acceptance_status: %w(wanted reserved) })
      .find { |application| application.job.admission == admission }
  end

  # Static because an applicant should be separated from the rest of the system
  def role_symbols
    # Think trice before changing this!
    return [:soker]
  end

  def can_recover_password?
    password_recoveries.where("created_at > ?", Time.current - 1.day).count < 5
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

  def is_logged?
    LogEntry.where(applicant_id: id).any?
  end

  class << self
    def authenticate(email, password)
      applicant = find_by_email(email.downcase)
      return applicant if applicant &&
        BCrypt::Password.new(applicant.hashed_password) == password
    end
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
