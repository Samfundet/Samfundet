class Feedback::Answer < ActiveRecord::Base
   attr_accessible :question_id, :answer, :token,
                   :date, :event_id, :survey_id

   validates_presence_of :answer
end
