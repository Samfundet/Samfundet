class Campus < ActiveRecord::Base
  attr_accessible :name
  has_many :applicants

  def to_s
    name
  end

  def number_of_applicants
    applicants.count
  end

end
