class Feedback < ActiveRecord::Base
   has_many :questions

   belongs_to :event

   attr_accessible :questions, :event

end
