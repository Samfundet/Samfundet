# frozen_string_literal: true

class AdmissionsAdmin::InterviewGroupsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  before_action :load_info

  def index
    @interview_groups = InterviewGroup.where(admission_id: @admission.id, group_id: @group.id)
  end

  def show
    @interview_group = InterviewGroup.find(params[:id])
    @applicants = @interview_group.applicants_for_interview_group(@admission)
  end

  def show_applicants
    puts('THIS IS RUNNING')
    @interview_group = InterviewGroup.find(params[:id])
    @applicants = @interview_group.applicants_for_interview_group(@admission)
    render partial: 'show_applicants_form'
  end

  def new
    @interview_group = InterviewGroup.new
    @available_jobs = @group.jobs_without_interview_groups(@admission)
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
    puts(@admission)
    @available_jobs = @interview_group.jobs + @group.jobs_without_interview_groups(@admission)
  end

  def update
    @interview_group.update(interview_group_params)
    if @interview_group.save
      if not params[:has_job].nil?
        params[:has_job].each do |k, v|
          job = Job.find_by(id: k.to_i)
          @interview_group.jobs.push(job)
        end
      end
      flash[:success] = 'Intervjugruppen ble lagret!'
      redirect_to admissions_admin_admission_group_interview_groups_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @interview_group = InterviewGroup.find(params[:id])
    @interview_group.jobs.each do |job|
      job.interview_group_id = nil
      job.save!
    end
    @interview_group.destroy
    flash[:success] = 'Intervjugruppen ble slettet!'
    redirect_to admissions_admin_admission_group_interview_groups_path(@admission, @group)
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
