class Campus < ActiveRecord::Base
  attr_accessible :name
  has_many :applicants

  def to_s
    name
  end

  def number_of_applicants
    applicants.count
  end

  def number_of_applicants_current_admission
    Admission.current.first.job_applications.map(&:applicant).uniq(&:email).group_by(&:campus).values[name.to_i].count
  end
end
