class Feedback::Alternative < ActiveRecord::Base
  attr_accessible :text, :question

  belongs_to :question
  validates_presence_of :text
end
