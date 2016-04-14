# -*- encoding : utf-8 -*-
class AdmissionsAdmin::JobsController < ApplicationController
  layout "admissions"
  before_filter :before_new_and_create_and_search, only: [:new, :create, :search]
  filter_access_to [:new, :create, :search, :edit, :update, :show, :destroy], attribute_check: true

  def new
  end

  def create
    @job.attributes = params[:job]
    if @job.save
      flash[:success] = t('jobs.job_created')
      redirect_to admissions_admin_admission_group_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def show
    @group = Group.find(params[:group_id])
    @admission = Admission.find(params[:admission_id])
  end

  def search
    @query = "%#{params[:q]}%"
    @jobs = @group.jobs.where("title_no LIKE ? OR teaser_no LIKE ? OR description_no LIKE ? OR title_en LIKE ? OR teaser_en LIKE ? OR description_en LIKE ?", @query, @query, @query, @query, @query, @query).limit(10)
    render layout: false
  end

  def edit
  end

  def update
    if @job.update_attributes(params[:job])
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

  def before_new_and_create_and_search
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:group_id])
    @job = Job.new(admission: @admission, group: @group)
  end
end
