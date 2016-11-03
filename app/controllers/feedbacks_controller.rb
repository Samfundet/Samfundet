class FeedbacksController < ApplicationController

  filter_access_to [:admin], require: :edit
  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :feedbacks }

  def admin_applet
  end

  def admin
    @feedbacks = Feedback.all
  end

  def index
    @feedbacks = Feedback.all
  end

  def new
    @feedback = Feedback.new(
        questions: [Feedback::Question.new]
    )
  end
  
  def show
    @feedback = Feedback.find(params[:id])
  end

  def edit
    @feedback = Feedback.find(params[:id])
    @feedback.questions << Feedback::Question.new
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
    binding.pry
    @feedback = Feedback.find params[:id]
    for id, alternative in params[:alternative]
        @question = @feedback.questions[id]
        Feedback::Answer.create(
            alternative: alternative,
            question: @question
        )
    end
    redirect_to :root_path
  end

  def update
    @feedback = Feedback.find(params[:id])

    if @feedback.update_attributes(params[:feedback])
      flash[:success] = t("helpers.models.feedback.success.update")
    else
      flash.now[:error] = t("helpers.models.feedback.errors.update_fail")
    end
    redirect_to action: :edit
  end

  def destroy
    Feedback.find(params[:id]).destroy
    redirect_to action: :admin
  end
end
