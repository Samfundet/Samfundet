class Feedback::Answer < ActiveRecord::Base
   attr_accessible :question, :alternative, :client

   belongs_to :question

   validates_presence_of :alternative
end
