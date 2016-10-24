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
    #Find all job applications of the current admission, get the unique user and group by campus.
    campus_hash = Admission.current.first.job_applications.map(&:applicant).uniq.map(&:campus).group_by(&:name)

    #Count how many applicant belong to this campus
    campus_hash[self.name].length
  end
end
