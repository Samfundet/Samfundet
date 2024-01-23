# frozen_string_literal: true

class JobApplicationsController < ApplicationController
  layout 'admissions'
  load_and_authorize_resource only: %i[index update destroy up down]
  skip_authorization_check only: %i[create]

  def index
    @admissions = @current_user.job_applications.where(withdrawn: false).group_by { |job_application| job_application.job.admission }
  rescue
    flash[:error] = t('job_applications.application_not_found')
    redirect_to root_path
  end

  def create
    @job_application = JobApplication.new(job_application_params)

    if @job_application.job&.admission&.appliable?
      if logged_in? && can?(:create, JobApplication)
        if current_user.class == Applicant
          handle_create_application_when_logged_in
        else
          flash[:notice] = t('applicants.will_be_logged_out_as_member')
          handle_create_application_when_not_logged_in
        end
      else
        handle_create_application_when_not_logged_in
      end
    else
      flash[:error] = t('job_applications.cannot_apply_after_deadline')
      if @job_application.job
        redirect_to @job_application.job
      else
        redirect_to admissions_path
      end
    end
  end

  def update
    @job_application = JobApplication.find(params[:id])
    if @job_application.update(job_application_params)
      @job_application.update(withdrawn: false)
      flash[:success] = t('job_applications.application_updated')
      if current_user.class == Applicant
        redirect_to job_applications_path
      else
        redirect_to admissions_admin_admission_group_job_job_application_path(@job_application.job.admission, @job_application.job.group, @job_application.job, @job_application)
      end
    else
      render_application_form_with_errors
    end
  end

  def destroy
    JobApplication.find(params[:id]).update(withdrawn: true)
    flash[:success] = t('job_applications.application_deleted')
    if current_user.class == Applicant
      redirect_to job_applications_path
    else
      redirect_to admissions_admin_admission_group_job_job_application_path(@job_application.job.admission, @job_application.job.group, @job_application.job, @job_application)
    end
  end

  def up
    prioritize :higher
  end

  def down
    prioritize :lower
  end

private

  def prioritize(direction)
    if @job_application&.job&.admission&.prioritize?
      @job_application.send "move_#{direction}"
      @job_application.save!
    elsif request.xhr?
      render text: t('job_applications.cannot_prioritize_after_deadline'), status: 500
      return
    else
      flash[:error] = t('job_applications.cannot_prioritize_after_deadline')
    end
    redirect_to_applications
  end

  def redirect_to_applications
    redirect_to_if_not_ajax_request job_applications_path
  end

  def handle_create_application_when_not_logged_in
    @job_application.skip_applicant_validation!

    if @job_application.valid?
      session[:pending_application] = @job_application
      flash[:notice] = t('job_applications.login_to_complete')

      @applicant = Applicant.new # For the registration form
      render 'applicant_sessions/new'
    else
      render_application_form_with_errors
    end
  end

  def handle_create_application_when_logged_in
    @job_application.applicant = current_user

    if @job_application.save
      flash[:success] = t('job_applications.application_saved')
      redirect_to job_applications_path
    else
      render_application_form_with_errors
    end
  end

  def render_application_form_with_errors
    flash[:error] = @job_application.errors.full_messages.first
    redirect_to @job_application.job
  end

  def job_application_params
    params.require(:job_application).permit(:job_id, :motivation)
  end
end
