class Feedback::SurveysController < ApplicationController
  filter_access_to :answers, require: :edit

  def new
    @survey = Feedback::Survey.new
  end

  def show
    @survey = Feedback::Survey.find(params[:id])

    render layout: false if request.xhr?
  end

  def edit
    @survey = Feedback::Survey.find(params[:id])
  end

  def create
    @survey = Feedback::Survey.new(params[:feedback_survey])
    if @survey.save
      flash[:success] = t('feedback.create_success')
    else
      flash.now[:error] = t('feedback.create_error')
    end
    redirect_to controller: 'feedback/admin', action: :admin
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
  rescue ActiveRecord::ActiveRecordError => e
    puts e
    render json: { success: false, message: "Error" }
  end

  def answers
    @survey = Feedback::Survey.find(params[:survey_id])
    @answers = Feedback::Answer.where(survey_id: @survey.id)
                   .paginate(page: params[:page], per_page: 80)
                   .order(:date)

    respond_to do |format|
      format.html
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename='#{@survey.title}-#{DateTime.current.to_date}.csv'"
      end
    end
  end

  def update
    @survey = Feedback::Survey.find(params[:id])

    if @survey.update_attributes(params[:feedback_survey])
      flash[:success] = t("success.update")
    else
      flash.now[:error] = t("errors.update_fail")
    end
    redirect_to controller: 'feedback/admin', action: :admin
  end

  def destroy
    Feedback::Survey.find(params[:id]).destroy
    redirect_to controller: 'feedback/admin', action: :admin
  end
end
