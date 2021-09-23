# frozen_string_literal: true

class JobApplicationsController < ApplicationController
  layout 'admissions'
  load_and_authorize_resource only: %i[index update destroy up down]
  skip_authorization_check only: %i[create, book_interview_time]

  def index
    @current_admission = Admission.first
    @admissions = @current_user.job_applications.where(withdrawn: false).group_by { |job_application| job_application.job.admission }
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
      @job_application.update_attributes(withdrawn: false)
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
    JobApplication.find(params[:id]).update_attributes(withdrawn: true)
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

  def book_interview_time
    @job_application = JobApplication.find(params[:job_application_id])
    @applicant = @job_application.applicant
    @job = @job_application.job

    # The datetime and id of interview_time_slot is sent through the "format" parameter
    f = params[:format].to_s

    # The ID of the interview time slot is found on the very last characters of the "format" parameter
    interview_time_slot = InterviewTimeSlot.find_by(id: f[10, f.size-10])

    # If the ID is invalid, there will be no valid interview time slot.
    # Mainly to protect against URL tampering.
    if interview_time_slot == nil
      flash[:error] = t('job_applications.error_book_interview_time')
      redirect_to job_path(@job)
      return
    end

    # Convert the remainder of the "format" characters into a datetime object,
    # which can be passed into the interview object later.
    interview_time = "#{f[2, 2]}.#{f[0, 2]}.20#{f[4, 2]} #{f[6, 2]}:#{f[8, 2]}"

    # Security mechanism in order to check if the given interview_time
    # and interview_time_slot can be found in the suggestions list.
    suggestions = @job.interview_time_suggestions_for_applicant(@applicant)
    time_and_slot_exists = false

    # Mainly to protect against URL tampering, like above,
    # and against double booking of the same interview time.
    suggestions.each do |s|
      if s[1] == interview_time and s[0] == interview_time_slot
        time_and_slot_exists = true
        break
      end
    end

    if !time_and_slot_exists
      flash[:error] = t('job_applications.error_book_interview_time')
      redirect_to job_path(@job)
      return
    end

    new_interview = @job_application.find_or_create_interview
    new_interview.time = interview_time
    new_interview.location = interview_time_slot.location
    new_interview.interview_time_slot_id = interview_time_slot.id
    new_interview.save!

    flash[:success] = t('job_applications.interview_set')
    redirect_to job_path(@job)
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

  def send_job_application_confirmation_email
    @job = @job_application.job
    @applicant = current_user
    email_subject = "Takk for din søknad hos #{@job.group.name}!"
    JobApplicationConfirmationMailer.send_confirmation_email(@applicant, @job, email_subject).deliver
  end

  def handle_create_application_when_logged_in
    @job_application.applicant = current_user

    if @job_application.save
      flash[:success] = t('job_applications.application_sent')
      flash[:notice] = t('job_applications.email_confirmation')
      flash[:message] = t('job_applications.reminder_inbox')

      send_job_application_confirmation_email
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
