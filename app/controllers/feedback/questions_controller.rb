class Feedback::QuestionsController < ApplicationController

  def new
    @question = Feedback::Question.new
  end

  def edit
    @question = Feedback::Question.find(params[:id])
  end

  def create
    @question = Feedback::Question.new(params[:feedback_question])
    if @question.save
      flash[:success] = t('feedback.questions.create_success')
      redirect_to controller: 'feedback/admin', action: :admin
    else
      flash.now[:error] = t('feedback.questions.create_error')
      render :new
    end
  end

  def update
    @question = Feedback::Question.find(params[:id])

    if @question.update_attributes(params[:feedback_question])
      flash[:success] = t("success.update")
    else
      flash.now[:error] = t("errors.update_fail")
    end
    redirect_to controller: 'feedback/admin', action: :admin
  end

  def destroy
    Feedback::Question.find(params[:id]).destroy
    redirect_to action: :admin, controller: "feedback/admin"
  end
end
