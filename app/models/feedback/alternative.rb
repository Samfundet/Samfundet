class Feedback::Alternative < ActiveRecord::Base
  attr_accessible :text, :question, :index

  belongs_to :question
  validates_presence_of :text
  #validates :index, uniqueness: { scope: :question }
end
