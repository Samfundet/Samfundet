class Feedback::SurveysController < ApplicationController
  filter_access_to :answers, require: :edit

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
    @survey = Feedback::Survey.find params[:survey_id]

    Feedback::Answer.create!(
      token: params[:token],
      answer: params[:answer],
      question_id: params[:question_id],
      survey_id: params[:survey_id],
      event_id: params[:event_id],
      date: DateTime.now
    )

    render json: { success: true, message: "Success" }
  end

  def answers
    @survey = Feedback::Survey.find(params[:survey_id])
    @answers = Feedback::Answer.where(survey_id: @survey.id)
                   .paginate(page: params[:page], per_page: 80)
                   .order(:date)
  end

  def update
    @survey = Feedback::Survey.find(params[:id])

    if @survey.update_attributes(params[:survey])
      flash[:success] = t("success.update")
    else
      flash.now[:error] = t("errors.update_fail")
    end
    redirect_to action: :edit
  end

  def destroy
    Feedback::Survey.find(params[:id]).destroy
    redirect_to action: :admin
  end
end
