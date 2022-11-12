# frozen_string_literal: true

class UnavailableInterviewTimeSlot < ApplicationRecord
  belongs_to :applicant
  belongs_to :admission

  validates :applicant_id, :admission_id, :start_time, :end_time, presence: true

  validate :starts_before_ends, :minimum_time

  def starts_before_ends
    if start_time > end_time
      errors.add(:start_time, I18n.t('helpers.models.admission.unavailable_interview_time_slot.end_before_start'))
    end
  end

  def minimum_time
    if start_time + 40.minutes > end_time
      errors.add(:end_time, I18n.t('helpers.models.admission.unavailable_interview_time_slot.minimum_time'))
    end
  end
end
