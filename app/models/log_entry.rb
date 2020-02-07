# frozen_string_literal: true

class LogEntry < ApplicationRecord
  validates :log, :admission, :group, :applicant, :member, presence: true

  belongs_to :applicant
  belongs_to :admission
  belongs_to :group
  belongs_to :member

  default_scope { order(created_at: :asc) }

  def self.possible_log_entries
    if I18n.locale == :no
      [
        'Forsøkt ringt, tok ikke telefonen',
        'Ringt og tilbudt verv, venter på svar',
        'Ringt, venter fremdeles på svar',
        'Ringt og tilbudt verv, takket ja',
        'Ringt og tilbudt verv, takket nei',
        'Ringt og meddelt ingen tilbud om verv',
        'Sendt e-post og meddelt ingen tilbud om verv'
      ]
    elsif I18n.locale == :en
      [
        'Called, no reply',
        'Called and offered position, awaiting reply',
        'Called, still waiting for reply',
        'Called and offered position, the applicant accepted',
        'Called and offered position, the applicant declined',
        'Called and notified the applicant of our rejection',
        'Sent email and notified the applicant of our rejection'
      ]
    end
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
