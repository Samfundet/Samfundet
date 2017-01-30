class Feedback::SurveysController < ApplicationController

  filter_access_to [:admin, :answers], require: :edit
  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :surveys }

  def answers
    @survey = Feedback::Survey.find(params[:id])
    @answers = @survey.questions.each{ |q| q.answers }.flatten
  end

  def admin_applet
  end

  def admin
    @surveys = Feedback::Survey.all
    @questions = Feedback::Question.all
  end

  def index
    @surveys = Feedback::Survey.all
  end

  def new
    @survey = Feedback::Survey.new
  end
  
  def show
    @survey = Feedback::Survey.find(params[:id])
    @token = [DateTime.now, request.session_options[:id]].join
  end

  def edit
    @survey = Feedback::Survey.find(params[:id])
  end

  def create
    @survey = Feedback::Survey.new(params[:survey])
    if @survey.save
      flash[:success] = t('feedbacks.create_success')
    else
      flash.now[:error] = t('feedbacks.create_error')
    end
    redirect_to action: :edit
  end

  def answer
    @survey = Feedback::Survey.find params[:survey_id]
    questions = @survey.questions
    
    unless params[:alternative].nil?
      params[:alternative].each_with_index do |alternative, i|
        @question = questions[i]
        Feedback::Answer.where(token: params[:token]).first_or_create(
          alternative: alternative,
          question: @question
        )
      end
    end
    render json: { token: params[:token], alternative: params[:alternative] }
  end

  def update
    @survey = Feedback::Survey.find(params[:id])

    if @survey.update_attributes(params[:survey])
      flash[:success] = t("helpers.models.feedbacks.success.update")
    else
      flash.now[:error] = t("helpers.models.feedbacks.errors.update_fail")
    end
    redirect_to action: :edit
  end

  def destroy
    Feedback::Survey.find(params[:id]).destroy
    redirect_to action: :admin
  end
end
