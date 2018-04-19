class Feedback::Survey < ActiveRecord::Base
  has_and_belongs_to_many :questions, join_table: "feedback_surveys_questions", order: 'feedback_questions.index'
  has_many :events, foreign_key: 'feedback_survey_id'
  has_many :answers, through: :questions

  attr_accessible :questions, :question_ids, :questions_attributes, :events, :title,
                  :end_message, :open

  validates_presence_of :title, :questions

  accepts_nested_attributes_for :questions, allow_destroy: true, reject_if: :all_blank

  default_scope order("updated_at DESC")

  def to_s
    title
  end
end
