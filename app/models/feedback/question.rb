class Feedback::Question < ActiveRecord::Base
  attr_accessible :text, :survey, :alternatives_attributes, :index
  
  has_many :alternatives
  belongs_to :survey

  validates_presence_of :text
   
  accepts_nested_attributes_for :alternatives, allow_destroy: true, reject_if: :all_blank

  def to_s
      text
  end
end
