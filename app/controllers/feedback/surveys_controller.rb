class Feedback::SurveysController < ApplicationController

  def new
    @survey = Feedback::Survey.new
  end
  
  def show
    @survey = Feedback::Survey.find(params[:id])
    @token = request.session_options[:id]
  end

  def edit
    @survey = Feedback::Survey.find(params[:id])
  end

  def create
    @survey = Feedback::Survey.new(params[:survey])
    if @survey.save
      flash[:success] = t('feedback.create_success')
    else
      flash.now[:error] = t('feedback.create_error')
    end
    redirect_to action: :edit
  end

  def answer
    #binding.pry
    @survey = Feedback::Survey.find params[:survey_id]
    questions = @survey.questions
    params[:date] = DateTime.now
    
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
