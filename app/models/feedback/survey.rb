class Feedback::Survey < ActiveRecord::Base
  has_and_belongs_to_many :questions, join_table: "feedback_surveys_questions"
  has_many :events

  attr_accessible :questions, :questions_attributes, :events, :title,
                  :start_message, :end_message, :open

  validates_presence_of :title

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  def to_s
    title
  end
end
