# frozen_string_literal: true

class AdmissionsAdmin::InterviewGroupsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  before_action :load_info

  def index
    @interview_groups = InterviewGroup.where(admission: @admission, group: @group)
  end

  def show
    @interview_group = InterviewGroup.find(params[:id])
  end

  def show_unprocessed
    @applicants = @interview_group.applicants_for_interview_group
    @job_applications = []

    @applicants.each do |applicant|
      @job_applications.push(applicant.top_priority_job_application)
    end

    render partial: '_applicants'
  end

  def new
    @interview_group = InterviewGroup.new
    @available_jobs = @group.available_interview_group_jobs
  end

  def create
    @interview_group.update(interview_group_params)
    if @interview_group.save
      flash[:success] = t('jobs.job_created')
      redirect_to admissions_admin_admission_group_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def edit
    @interview_group = InterviewGroup.find(params[:id])
    @available_jobs = @interview_group.jobs + @group.available_interview_group_jobs
  end

  def update
    @interview_group.update(interview_group_params)
    if @interview_group.save
      flash[:success] = t('jobs.job_created')
      redirect_to admissions_admin_admission_group_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def set_interview
  end

private

  def interview_group_params
    params.require(:interview_group).permit(
      :name,
      :description
    )
  end

  def load_info
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:group_id])
  end
end
