class Feedbacks::QuestionsController < ApplicationController
     
  def new
    @question = Feedback::Question.new
  end

  def edit
    @question = Feedback::Question.find(params[:id])
  end

  def create
    @question = Feedback::Question.new(params[:question])
    if @question.save
      flash[:success] = t('feedbacks.create_success')
    else
      flash.now[:error] = t('feedbacks.create_error')
    end
    redirect_to action: :edit
  end

  def update
    @question = Feedback::Question.find(params[:id])

    if @question.update_attributes(params[:question])
      flash[:success] = t("helpers.models.feedbacks.success.update")
    else
      flash.now[:error] = t("helpers.models.feedbacks.errors.update_fail")
    end
    redirect_to action: :edit
  end

  def destroy
    Feedback::Question.find(params[:id]).destroy
    redirect_to action: "feedbacks#admin"
  end
end
