class Feedback::Question < ActiveRecord::Base
  has_many :alternatives
  has_and_belongs_to_many :surveys, join_table: "feedback_surveys_questions"

  attr_accessible :text, :surveys, :alternatives, :alternatives_attributes, :index

  validates_presence_of :text

  accepts_nested_attributes_for :alternatives, allow_destroy: true, reject_if: :all_blank

  def to_s
      text
  end
end
