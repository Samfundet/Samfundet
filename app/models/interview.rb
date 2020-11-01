# frozen_string_literal: true

class Interview < ApplicationRecord
  belongs_to :job_application
  #  has_one :group, through: :job_application

  scope :with_time_set, -> { where('time > 0') }

  PRIORITIES_NO = {wanted: 'Vil ha',
                   reserved: 'Reserve',
                   not_wanted: 'Vil ikke ha',
                   nil => 'Ikke satt' }.freeze

  PRIORITIES_EN = {wanted: 'Wanted',
                   reserved: 'Backup',
                   not_wanted: 'Not wanted',
                   nil => 'Not set' }.freeze

  APPLICANT_STATUS_NO = {accepted: 'Tilbud, takket ja',
                   declined: 'Tilbud, takket nei',
                   rejected: 'Send avslag på epost',
                   rejected_m: 'Avslag, kontaktet direkte',
                   nil => 'Ikke satt' }.freeze

  APPLICANT_STATUS_EN = {accepted: 'Accepted',
                   declined: 'Declined offer',
                   rejected: 'Not accepted',
                   rejected_m: 'Contacted about rejection',
                   nil => 'Not set' }.freeze

  validates :priority,
            inclusion: { in: PRIORITIES_NO.keys,
                         message: 'Invalid priority' }

  validates :applicant_status,
            inclusion: { in: APPLICANT_STATUS_NO.keys,
                         message: 'Invalid applicant status' }

  def priority
    field = self[:priority]
    field = nil if field&.empty?
    field.to_sym if field.present?
  end

  def priority=(value)
    self[:priority] = value.to_s
  end

  def group
    job_application.job.group
  end

  def priority_string
    if I18n.locale == :no
      PRIORITIES_NO[priority]
    elsif I18n.locale == :en
      PRIORITIES_EN[priority]
    end
  end

  def priorities
    if I18n.locale == :no
      PRIORITIES_NO
    elsif I18n.locale == :en
      PRIORITIES_EN
    end
  end

  def applicant_status
    field = self[:applicant_status]
    field = nil if field&.empty?
    field.to_sym if field.present?
  end

  def applicant_status=(value)
    self[:applicant_status] = value.to_s
  end

  def applicant_status_string
    if I18n.locale == :no
      APPLICANT_STATUS_NO[applicant_status]
    elsif I18n.locale == :en
      APPLICANT_STATUS_NO[applicant_status]
    end
  end

  def applicant_statuses
    if I18n.locale == :no
      APPLICANT_STATUS_NO
    elsif I18n.locale == :en
      APPLICANT_STATUS_EN
    end
  end

  def past_set_priority_deadline?
    job_application.job.admission.admin_priority_deadline < Time.current
  end

end

# == Schema Information
#
# Table name: interviews
#
#  id                 :bigint           not null, primary key
#  time               :datetime
#  priority  :string(10)
#  job_application_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  location           :string
#  comment            :text
#
