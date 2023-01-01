# frozen_string_literal: true

class AdmissionsAdmin::InterviewGroupsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  before_action :load_info

  def index
    @interview_groups = InterviewGroup.where(admission_id: @admission.id, group_id: @group.id)
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
    @available_jobs = @interview_group.available_jobs
  end

  def create
    @interview_group = InterviewGroup.new(interview_group_params)
    @interview_group.admission_id = @admission.id
    @interview_group.group_id = @group.id

    if @interview_group.save
      if not params[:has_job].nil?
        params[:has_job].each do |k, v|
          job = Job.find_by(id: k.to_i)
          @interview_group.jobs.push(job)
        end
      end
      flash[:success] = 'Intervjugruppen ble opprettet!'
      redirect_to admissions_admin_admission_group_interview_groups_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def edit
    @interview_group = InterviewGroup.find(params[:id])
    @available_jobs = @interview_group.jobs + @interview_group.available_jobs
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
    puts('INFO IS LAODED')
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:group_id])
  end
end
