# frozen_string_literal: true

class Group < ApplicationRecord
  belongs_to :group_type
  belongs_to :page
  has_many :jobs
  has_many :roles
  has_many :job_applications, through: :jobs
  has_many :interviews, through: :job_applications
  has_many :events, as: :organizer

  validates :name, :group_type, presence: true
  validates :name, uniqueness: true
  validates_associated :group_type

  default_scope { order(:name).includes(:page) }

  def <=>(other)
    name <=> other.name
  end

  def short_name
    if abbreviation.blank?
      name
    else
      abbreviation
    end
  end

  def interviews
    Interview.all.select { |i| self == i.group }
  end

  def jobs_in_admission(admission)
    jobs.select { |j| j.admission_id == admission.id }
  end

  def job_applications_in_admission(admission)
    job_applications.select { |j| j.job.admission == admission }
  end

  def to_s
    if abbreviation.blank?
      name
    else
      "#{name} (#{abbreviation})"
    end
  end

  def to_param
    if short_name.nil?
      super
    else
      "#{id}-#{short_name.parameterize}"
    end
  end

  # Role symbol generators

  def admission_responsible_role
    "#{member_role}_opptaksansvarlig".to_sym
  end

  def group_leader_role
    "#{member_role}_gjengsjef".to_sym
  end

  def event_manager_role
    "#{member_role}_arrangementansvarlig".to_sym
  end

  def member_role
    role = short_name.downcase.to_s
    role.tr! 'æ', 'ae'
    role.tr! 'ø', 'oe'
    role.tr! 'å', 'aa'
    role.tr! ' ', '_'
    role.gsub!(/[^a-zA-Z_0-9]/, '')
    role.to_sym
  end

  def applicants(admission)
    admission.job_applications.select { |job_application| job_application.job.group_id == id }.map(&:applicant).uniq
  end

  def applicants_to_call(admission)
    job_applications = admission.job_applications.select { |job_application| job_application.job.group_id == id && job_application.withdrawn == false }
    job_applications.select { |job_application| job_application.applicant.lowest_priority_group(admission) == id && job_application.withdrawn == false }.map(&:applicant).uniq.select { |applicant| applicant.unwanted?(admission) }
  end
end

# == Schema Information
#
# Table name: groups
#
#  id                :bigint           not null, primary key
#  name              :string
#  abbreviation      :string
#  website           :string
#  group_type_id     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  short_description :text
#  long_description  :text
#  page_id           :integer
#
