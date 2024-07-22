# frozen_string_literal: true

class Admission < ApplicationRecord
  has_many :jobs
  has_many :job_applications, -> { distinct }, through: :jobs
  has_many :groups, -> { distinct }, through: :jobs
  has_many :group_types, -> { distinct }, through: :groups
  has_many :rejection_emails

  validates :title, :shown_from, :shown_application_deadline,
            :actual_application_deadline, :user_priority_deadline,
            :admin_priority_deadline, presence: true
  validates :shown_from,
            :shown_application_deadline,
            :actual_application_deadline,
            :user_priority_deadline,
            :admin_priority_deadline,
            format: { with: /\A[0-3][0-9].[01][0-9].[0-9]{4,4}  # The date.
                     \                                  # A space.
                     [0-2][0-9]:[0-5][0-9]\Z/x } # The time.

  validates :promo_video, url: true, if: :promo_video_empty?

  def promo_video_empty?
    !promo_video.empty?
  end

  # An admission has five datetimes associated with it:
  #
  #   shown_from                  - The admission is shown on the front page
  #                                 from that datetime.
  #   shown_application_deadline  - The datetime specifying the application
  #                                 deadline to the user.
  #   actual_application_deadline - The actual deadline for applying. From our
  #                                 experience, some users are slow.
  #   user_priority_deadline      - The deadline for users to prioritize their
  #                                 applications.
  #   admin_priority_deadline     - The deadline for admissions admins to
  #                                 prioritize their applicants.

  validates_each :shown_application_deadline do |record, attr, value|
    objects_exist = !value.nil? && !record.shown_from.nil?
    if objects_exist && value < record.shown_from
      record.errors.add(
        attr,
        I18n.t('helpers.models.admission.errors.deadline_before_visible')
      )
    end
  end

  validates_each :actual_application_deadline do |record, attr, value|
    objects_exist = !value.nil? && !record.shown_application_deadline.nil?
    if objects_exist && value < record.shown_application_deadline
      record.errors.add(
        attr,
        I18n.t('helpers.models.admission.errors.deadline_before_shown_deadline')
      )
    end
  end

  validates_each :user_priority_deadline do |record, attr, value|
    objects_exist = !value.nil? && !record.actual_application_deadline.nil?
    if objects_exist && value < record.actual_application_deadline
      record.errors.add(
        attr,
        I18n.t('helpers.models.admission.errors.priority_before_application')
      )
    end
  end

  validates_each :admin_priority_deadline do |record, attr, value|
    objects_exist = !value.nil? && !record.user_priority_deadline.nil?
    if objects_exist && value < record.user_priority_deadline
      record.errors.add(
        attr,
        I18n.t('helpers.models.admission.errors.admin_deadline_before_user')
      )
    end
  end

  default_scope { order(is_primary: :desc, shown_application_deadline: :desc) }

  # We must use lambdas so that the time is not 'cached' on server start.
  scope :current, (lambda do
    where('user_priority_deadline > ?', 2.weeks.ago)
    .order('user_priority_deadline DESC')
  end)

  scope :appliable, (lambda do
    where('shown_from < ? and actual_application_deadline > ?',
          Time.current, Time.current)
  end)

  scope :active, (lambda do
    where('shown_from < ? and admin_priority_deadline > ?',
          Time.current, Time.current)
  end)

  scope :no_longer_appliable, (lambda do
    where('actual_application_deadline < ?', Time.current)
  end)

  scope :upcoming, (lambda do
    where('shown_from > ?', Time.current)
  end)

  # Remember that scopes are composable, meaning that one could
  # call "Admission.appliable.with_relations".
  scope :with_relations, -> { includes(jobs: { group: :group_type }) }

  def self.open_admissions?
    !Admission.appliable.empty?
  end

  # Defined as at admin priority deadline not passed
  def self.active_admissions?
    Admission.active.any?
  end

  def custom_group_types
    jobs.map { |job| job.custom_group_type }.to_set.sort_by { |s| s=='' ?  'zzz' : s }
  end

  def custom_group(group_type)
    jobs.filter { |job| job.custom_group_type == group_type }
      .map(&:custom_group)
      .to_set.sort_by { |s| s=='' ? 'zzz' : s }
  end

  def jobs_in_custom_group(group, group_type)
    jobs.select { |job| job.custom_group==group && job.custom_group_type==group_type }
  end

  def appliable?
    (actual_application_deadline > Time.current) && (shown_from < Time.current)
  end

  def prioritize?
    user_priority_deadline > Time.current
  end

  def interview_dates
    from = actual_application_deadline.to_date + 1.day
    to   = user_priority_deadline.to_date

    (from..to).to_a
  end

  def to_s
    "#{title} (#{I18n.localize shown_application_deadline, format: :short})"
  end

  def to_param
    if title.nil?
      super
    else
      "#{id}-#{title.parameterize}"
    end
  end
end


# == Schema Information
#
# Table name: admissions
#
#  id                             :bigint           not null, primary key
#  title                          :string
#  shown_application_deadline     :datetime
#  user_priority_deadline         :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  shown_from                     :datetime
#  admin_priority_deadline        :datetime
#  actual_application_deadline    :datetime
#  promo_video                    :string           default("https://www.youtube.com/embed/T8MjwROd0dc")
#  groups_with_separate_admission :text
#  is_primary                     :boolean          default(false)
#
