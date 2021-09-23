# frozen_string_literal: true

class Job < ApplicationRecord
  belongs_to :admission, touch: true
  belongs_to :group

  has_one :group_type, -> { order(:description) }, through: :group
  has_many :job_applications
  has_many :interview_time_slots, foreign_key: 'job_id'
  has_many :interviews, through: :job_applications
  has_many :applicants, through: :job_applications

  has_and_belongs_to_many :tags, class_name: 'JobTag'

  validates :title_no, :teaser_no, :description_no, :admission, :group, :contact_email, :contact_phone, :interview_interval, presence: true
  validates :teaser_no, :teaser_en, length: { maximum: 75 }

  validate :linkable_and_same_intervals

  # scope :appliable

  extend LocalizedFields
  localized_fields :title, :description, :teaser, :default_motivation_text

  def available_jobs_in_same_group
    group.jobs.where('admission_id = (?) AND id <> ?', admission_id, id)
  end

  def linkable_and_same_intervals
    if linkable_interviews
      @other_jobs = Job.where(admission: admission, group: group)
      @other_jobs.each do |j|
        if j.interview_interval != interview_interval
          errors.add(:linkable_interviews, I18n.t('helpers.models.job.errors.linkable_different_intervals'))
          break
        end
      end
    end
  end

  def similar_available_jobs
    jobs = Job.where('admission_id = (?) AND id IN (SELECT DISTINCT job_id FROM job_tags_jobs WHERE job_tag_id IN (?))', admission_id, tags.collect(&:id))

    # Remove self from similar jobs
    jobs - [self]
  end

  def to_param
    if title.nil?
      super
    else
      "#{id}-#{title.parameterize}"
    end
  end

  def <=>(other)
    title <=> other.title
  end

  # Virtual tags attribute
  def tag_titles=(titles)
    old_tags = tags
    new_tags = titles
               .split(',')
               .map(&:strip)
               .reject(&:empty?)
               .map { |title| JobTag.find_or_create_by(title: title.downcase) }
    tags.delete(tags - old_tags)
    self.tags = new_tags
  end

  def tag_titles
    tags.map(&:title).join(', ')
  end

  def job_applications_with_interviews
    job_applications.select { |j| j.interview&.time }
  end

  def job_applications_without_interviews
    unprocessed = unprocessed_applications
    unprocessed - job_applications_with_interviews
  end

  def processed_applications
    processed = job_applications.where(withdrawn: false)
        .joins(:interview)
    processed.select { |u| u.interview.applicant_status.present? }
  end

  def active_applications
    job_applications.where(withdrawn: false)
  end

  def unprocessed_applications
    unprocessed = job_applications.where(withdrawn: false)
        .joins(:interview)
    unprocessed = unprocessed.select { |u| u.interview.applicant_status.blank? }
    # Must add those without an interview model too
    no_interview_model_created = job_applications - job_applications.joins(:interview)
    unprocessed + no_interview_model_created
  end

  def get_set_interview_times
    taken_times = []
    @applications = job_applications_with_interviews
    @applications.each do |a|
      interview = a.find_or_create_interview

      range = interview_interval - 1
      start_time = interview.time - range.minutes
      count = 2*interview_interval - 1

      count.times do |x|
        taken_times.push((start_time + x.minutes).to_s)
      end
    end

    taken_times
  end

  # Accepted applications (that also said yes)
  def accepted_applications
    job_applications
        .where(withdrawn: false)
        .joins(:interview)
        .where(interviews: { applicant_status: :accepted })
  end

  def contacted_applications
    job_applications
        .where(withdrawn: false)
        .joins(:interview)
        .where(
            'interviews.applicant_status=? OR interviews.applicant_status=? OR interviews.applicant_status=?',
            :accepted, :declined, :rejected_m
        )
  end

  def automatically_rejected_applications
    job_applications
        .where(withdrawn: false)
        .joins(:interview)
        .where(interviews: { applicant_status: :rejected })
  end

  def withdrawn_applications
    job_applications.where(withdrawn: true)
  end

private

  def appliable_admission_ids
    Admission.appliable.collect(&:id)
  end
end

# == Schema Information
#
# Table name: jobs
#
#  id                         :bigint           not null, primary key
#  group_id                   :integer
#  admission_id               :integer
#  title_no                   :string
#  title_en                   :string
#  teaser_no                  :string
#  teaser_en                  :string
#  description_en             :text
#  description_no             :text
#  is_officer                 :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  default_motivation_text_no :text
#  default_motivation_text_en :text
#
