class Feedback::AdminController < ApplicationController
  filter_access_to [:admin, :answers], require: :edit
  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :feedback_surveys }

  def admin_applet
  end

  def admin
    @surveys = Feedback::Survey.all
    @questions = Feedback::Question.all
  end

  def index
    @surveys = Feedback::Survey.all
  end
  
  def answers
    @survey = Feedback::Survey.find(params[:id])
    @answers = @survey.questions.each{ |q| q.answers }.flatten
  end

end
