class Feedback < ActiveRecord::Base
   has_many :questions

   has_many :events

   attr_accessible :questions, :questions_attributes, :events, :title

   validates_presence_of :title

   accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank
end
