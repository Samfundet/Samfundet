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
  end

  def index
    @feedbacks = Feedback.all
  end

  def new
    @feedback = Feedback.new
  end
  
  def show
    @feedback = Feedback.find(params[:id])
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
    params[:alternative].each_with_index do |alternative, i|
        @question = @feedback.questions[i]
        Feedback::Answer.where(client: params[:client]).first_or_create(
            alternative: alternative,
            question: @question
        )
    end
    flash[:success] = t("feedback.complete")
    redirect_to :root
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
