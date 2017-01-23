class FeedbacksController < ApplicationController

  filter_access_to [:admin, :answers], require: :edit
  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :feedbacks }

  def answers
    @feedback = Feedback.find(params[:id])
    @answers = @feedback.questions.each{ |q| q.answers }.flatten
  end

  def admin_applet
  end

  def admin
    @feedbacks = Feedback.all
    @questions = Feedback::Question.all
  end

  def index
    @feedbacks = Feedback.all
  end

  def new
    @feedback = Feedback.new
  end
  
  def show
    @feedback = Feedback.find(params[:id])
    @token = [DateTime.now, request.session_options[:id]].join
  end

  def edit
    @feedback = Feedback.find(params[:id])
  end

  def create
    @feedback = Feedback.new(params[:feedback])
    if @feedback.save
      flash[:success] = t('feedbacks.create_success')
    else
      flash.now[:error] = t('feedbacks.create_error')
    end
    redirect_to action: :edit
  end

  def answer
    @feedback = Feedback.find params[:feedback_id]
    questions = @feedback.questions
    
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
    @feedback = Feedback.find(params[:id])

    if @feedback.update_attributes(params[:feedback])
      flash[:success] = t("helpers.models.feedbacks.success.update")
    else
      flash.now[:error] = t("helpers.models.feedbacks.errors.update_fail")
    end
    redirect_to action: :edit
  end

  def destroy
    Feedback.find(params[:id]).destroy
    redirect_to action: :admin
  end
end
