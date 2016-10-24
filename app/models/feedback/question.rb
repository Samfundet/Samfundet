class Feedback::Question < ActiveRecord::Base
  attr_accessible :text, :feedback, :answers, :alternatives
  
  has_many :answers
  has_many :alternatives
  belongs_to :feedback

  validates_presence_of :text
   
  accepts_nested_attributes_for :alternatives, allow_destroy: true, reject_if: :all_blank

end
