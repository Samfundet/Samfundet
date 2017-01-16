# -*- encoding : utf-8 -*-
class JobApplicationsController < ApplicationController
  layout "admissions"
  filter_access_to [:index]
  filter_access_to [:update, :destroy, :up, :down], attribute_check: true

  def index
    @admissions = @current_user.job_applications.group_by { |job_application| job_application.job.admission }
  end

  def create
    @job_application = JobApplication.new(params[:job_application])

    if @job_application.job && @job_application.job.admission.actual_application_deadline > Time.current
      if logged_in? && permitted_to?(:create, :job_applications)
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
    if @job_application.update_attributes(params[:job_application])
      @job_application.update_attribute(:withdrawn, false)
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
    JobApplication.find(params[:id]).update_attribute(:withdrawn, true)
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
    if @job_application && @job_application.job.admission.user_priority_deadline > Time.current
      @job_application.send "move_#{direction}"
      @job_application.save!
    else
      if request.xhr?
        render text: t('job_applications.cannot_prioritize_after_deadline'), status: 500
        return
      else
        flash[:error] = t('job_applications.cannot_prioritize_after_deadline')
      end
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
end
