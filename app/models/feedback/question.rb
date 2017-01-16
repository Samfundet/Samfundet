class Feedback::Question < ActiveRecord::Base
  attr_accessible :text, :feedback, :answers, :alternatives, :index
  
  has_many :answers
  has_many :alternatives
  belongs_to :feedback

  validates_presence_of :text
  #validates :index, uniqueness: { scope: :feedback }
   
  accepts_nested_attributes_for :alternatives, allow_destroy: true, reject_if: :all_blank

  def to_s
      text
  end
end
