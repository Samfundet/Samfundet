# frozen_string_literal: true

class InterviewTimeSlot < ApplicationRecord
  belongs_to :job
  belongs_to :group
  belongs_to :admission
  has_many :interviews
  validates :job_id, :group_id, :admission_id, :location, :start_time, :end_time, presence: true
  validate :is_one_day_in_future, :is_same_day, :starts_before_ends, :minimum_time

  def is_one_day_in_future
    if start_time < Date.tomorrow
      errors.add(:start_time, I18n.t('helpers.models.admission.interview_time_slot.one_day_future'))
    end
  end

  def is_same_day
    if start_time.to_date != end_time.to_date
      errors.add(:end_time, I18n.t('helpers.models.admission.interview_time_slot.same_day'))
    end
  end

  def starts_before_ends
    if start_time > end_time
      errors.add(:end_time, I18n.t('helpers.models.admission.interview_time_slot.end_before_start'))
    end
  end

  def minimum_time
    if start_time + 40.minutes > end_time
      errors.add(:end_time, I18n.t('helpers.models.admission.interview_time_slot.minimum_time'))
    end
  end

  def number_of_interviews
    unique_times = []
    interviews.each do |i|
      time = i.time
      if !unique_times.include? time
        unique_times.push(time)
      end
    end

    unique_times.length
  end

  def possible_times(unavailable_times)
    times = []
    interval = job.interview_interval

    next_time = start_time
    while next_time < end_time
      if next_time > Time.now + 24.hours and next_time + interval.minutes <= end_time and !unavailable_times.include? (next_time + interval.minutes).to_s
        times.push(next_time.to_s)
      end
      next_time = next_time + interval.minutes
    end

    interviews.each do |interview|
      time = interview.time.to_s
      if times.include? time
        times.delete_at(times.index(time))
      end
    end

    times
  end
end
