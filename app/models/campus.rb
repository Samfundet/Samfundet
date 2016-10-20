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
    Admission.current.first.job_applications.map { |application| \
        application.applicant }.uniq{|applicant| applicant.email\
    }.group_by{ |applicant| applicant.campus }.values[self.name.to_i].count
  end

end
