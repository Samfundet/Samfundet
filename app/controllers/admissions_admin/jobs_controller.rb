# frozen_string_literal: true

class AdmissionsAdmin::JobsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'
  before_action :before_new_and_create_and_search, only: %i[new create search]

  def new; end

  def create
    @job.update(job_params)
    if @job.save
      flash[:success] = t('jobs.job_created')
      redirect_to admissions_admin_admission_group_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def show
    @job = Job.find(params[:id])
    @group = Group.find(params[:group_id])
    @admission = Admission.find(params[:admission_id])

    @accepted_applications = @job.accepted_applications
    @unprocessed_applications = @job.unprocessed_applications
    @contacted_applications = @job.contacted_applications
    @auto_rejected_applications = @job.automatically_rejected_applications
    @withdrawn_applications = @job.withdrawn_applications
  end

  def show_unprocessed
    @job = Job.find(params[:job_id])
    if !can?(:show_unprocessed, @job)
      permission_denied
      return
    end

    @groupings = [@job.unprocessed_applications]
    @group = Group.find(params[:group_id])
    @admission = Admission.find(params[:admission_id])

    render partial: 'jobs_show'
  end

  def search
    @query = "%#{params[:q]}%"
    @jobs = @group.jobs.where('title_no LIKE ? OR teaser_no LIKE ? OR description_no LIKE ? OR title_en LIKE ? OR teaser_en LIKE ? OR description_en LIKE ?', @query, @query, @query, @query, @query, @query).limit(10)
    render layout: false
  end

  def edit; end

  def update
    if @job.update_attributes(job_params)
      flash[:success] = t('jobs.job_updated')
      redirect_to admissions_admin_admission_group_path(@job.admission, @job.group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @job.destroy
    flash[:success] = t('jobs.job_deleted')
    redirect_to admissions_admin_admission_group_path(@job.admission, @job.group)
  end

private

  def job_params
    params.require(:job).permit(
      :title_no,
      :title_en,
      :teaser_no,
      :teaser_en,
      :description_no,
      :description_en,
      :default_motivation_text_no,
      :default_motivation_text_en,
      :is_officer,
      :tag_titles,
      :custom_group,
      :custom_group_type
    )
  end

  def before_new_and_create_and_search
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:group_id])
    @job = Job.new(admission: @admission, group: @group)
  end
end
