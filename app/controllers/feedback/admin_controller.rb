class Feedback::AdminController < ApplicationController
  filter_access_to [:admin], require: :edit
  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :feedback_surveys }

  def admin_applet
  end

  def admin
    @surveys = Feedback::Survey.all
    @questions = Feedback::Question.order("updated_at DESC")
  end

  def index
    @surveys = Feedback::Survey.all
  end

end
