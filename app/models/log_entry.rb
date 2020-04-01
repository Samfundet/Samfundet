# frozen_string_literal: true

class LogEntry < ApplicationRecord
  validates :log, :admission, :group, :applicant, :member, presence: true

  belongs_to :applicant
  belongs_to :admission
  belongs_to :group
  belongs_to :member

  default_scope { order(created_at: :asc) }

  def self.possible_log_entries
    [
      I18n.t('activerecord.models.possible_log_entries.called_no_answer'),
      I18n.t('activerecord.models.possible_log_entries.called_offered_job_waiting'),
      I18n.t('activerecord.models.possible_log_entries.called_still_waiting'),
      I18n.t('activerecord.models.possible_log_entries.called_offered_job_accepted'),
      I18n.t('activerecord.models.possible_log_entries.called_offered_job_declined'),
      I18n.t('activerecord.models.possible_log_entries.called_no_offer'),
      I18n.t('activerecord.models.possible_log_entries.emailed_no_offer')
    ]
  end

  def self.acceptance_log_entry
    possible_log_entries[3]
  end

  def is_acceptance_log_entry?
    log == LogEntry.possible_log_entries[3]
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: log_entries
#
#  id           :integer          not null, primary key
#  log          :string(255)
#  admission_id :integer
#  group_id     :integer
#  applicant_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  member_id    :integer
#
