class Campus < ActiveRecord::Base
  attr_accessible :name, :active
  has_many :applicants

  def to_s
    name
  end

  def number_of_applicants
    applicants.count
  end

  def self.number_of_applicants_current_admission
    # Find all job applications of the current admission, get the unique user_id and group by campus_id.
    applicant_ids = Admission.current.first.job_applications.pluck(:applicant_id)
    campus_count = {}
    Applicant.where(id:applicant_ids).pluck(:campus_id).group_by{|i| i}.each{ |k,v| campus_count[k] = v.length}
    campus_count.default = 0
    campus_count
  end
end
