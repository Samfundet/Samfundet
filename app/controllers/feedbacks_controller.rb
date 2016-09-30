class FeedbacksController < ApplicationController

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

  def update
    @feedback = Feedback.find(params[:id])

    if @feedback.update_attributes(params[:feedback])
      flash[:success] = t("helpers.models.feedback.success.update")
    else
      flash.now[:error] = t("helpers.models.feedback.errors.update_fail")
      render :edit
    end
  end

  def destroy
    Feedback.find(params[:id]).destroy
  end
end
