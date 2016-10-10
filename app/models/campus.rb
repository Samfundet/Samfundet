class Campus < ActiveRecord::Base

  attr_accessible :name
  has_many :applicants

  def to_s
    self.name
  end
end
