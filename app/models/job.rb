# -*- encoding : utf-8 -*-
class Job < ActiveRecord::Base
  belongs_to :admission, touch: true
  belongs_to :group

  has_one :group_type, through: :group, order: 'description'
  has_many :job_applications
  has_many :interviews, through: :job_applications
  has_many :applicants, through: :job_applications

  has_and_belongs_to_many :tags, class_name: 'JobTag'

  validates_presence_of :title_no, :teaser_no, :description_no, :admission, :group
  validates :teaser_no, :teaser_en, length: { maximum: 75 }

  scope :appliable

  extend LocalizedFields
  has_localized_fields :title, :description, :teaser, :default_motivation_text

  def available_jobs_in_same_group
    group.jobs.where("admission_id IN (?) AND id <> ?", appliable_admission_ids, id)
  end

  def similar_available_jobs
    jobs = Job.where("admission_id IN (?) AND id IN (SELECT DISTINCT job_id FROM job_tags_jobs WHERE job_tag_id IN (?))", appliable_admission_ids, tags.collect(&:id))

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
    old_tags = self.tags
    new_tags = titles.split(/[,\s]+/).map { |title| JobTag.find_or_create_by_title(title) }
    tags.delete (self.tags - old_tags)
    self.tags = new_tags
  end
  def tag_titles
    tags.map(&:title).join(", ")
  end

  def job_applications_with_interviews
    job_applications.select { |j| j.interview && j.interview.time }
  end

  def job_applications_without_interviews
    job_applications - job_applications_with_interviews
  end

  private

  def appliable_admission_ids
    Admission.appliable.collect(&:id)
  end
end

# == Schema Information
# Schema version: 20130422173230
#
# Table name: jobs
#
#  id                         :integer          not null, primary key
#  group_id                   :integer
#  admission_id               :integer
#  title_no                   :string(255)
#  title_en                   :string(255)
#  teaser_no                  :string(255)
#  teaser_en                  :string(255)
#  description_en             :text
#  description_no             :text
#  is_officer                 :boolean
#  created_at                 :datetime         not null
#  updated_at                 :datetime         not null
#  default_motivation_text_no :text
#  default_motivation_text_en :text
#
