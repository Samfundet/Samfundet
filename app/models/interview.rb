# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class Interview < ActiveRecord::Base
  belongs_to :job_application
  #  has_one :group, through: :job_application

  scope :with_time_set, -> { where('time > 0') }

  ACCEPTANCE_STATUSES_NO = { wanted: 'Vil ha',
                             reserved: 'Reserve',
                             not_wanted: 'Vil ikke ha',
                             nil => 'Ikke satt' }.freeze
  ACCEPTANCE_STATUSES_EN = { wanted: 'Wanted',
                             reserved: 'Backup',
                             not_wanted: 'Not wanted',
                             nil => 'Not set' }.freeze

  validates :acceptance_status,
            inclusion: { in: ACCEPTANCE_STATUSES_NO.keys,
                         message: 'Invalid acceptance status' }

  def acceptance_status
    field = self[:acceptance_status]
    field = nil if field && field.empty?
    return field.to_sym unless field.blank?
  end

  def acceptance_status=(value)
    self[:acceptance_status] = value.to_s
  end

  def group
    job_application.job.group
  end

  def acceptance_status_string
    if I18n.locale == :no
      ACCEPTANCE_STATUSES_NO[acceptance_status]
    elsif I18n.locale == :en
      ACCEPTANCE_STATUSES_EN[acceptance_status]
    end
  end

  def ACCEPTANCE_STATUSES
    if I18n.locale == :no
      ACCEPTANCE_STATUSES_NO
    elsif I18n.locale == :en
      ACCEPTANCE_STATUSES_EN
    end
  end

  def past_set_status_deadline?
    job_application.job.admission.admin_priority_deadline < Time.current
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: interviews
#
#  id                 :integer          not null, primary key
#  time               :datetime
#  acceptance_status  :string(10)
#  job_application_id :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
