# frozen_string_literal: true

class ApplicantSessionsController < UserSessionsController
  skip_authorization_check
  layout 'admissions'

  def new
    @applicant = Applicant.new
    @redirect_to = params[:redirect_to] || request_referer_if_on_current_domain
  end

  def create
    applicant = Applicant.authenticate(
      params[:applicant_login_field],
      params[:applicant_login_password]
    )


    if applicant.nil?
      if Applicant.valid_email?(params[:applicant_login_field])
        @applicant_login_email = params[:applicant_login_field]
      elsif Applicant.valid_phone?(params[:applicant_login_field])
        @applicant_login_phone = params[:applicant_login_field]
      else
        flash[:error] = t('applicants.login_input_error')
        redirect_to applicant_login_path
        return
      end

      @applicant = Applicant.new
      flash[:error] = t('applicants.login_error')

      render :new
      return
    end

    login_applicant applicant

    if pending_application?
      save_pending_application(applicant)
      flash[:success] = t('applicants.login_success_application_saved', name: CGI.escapeHTML(applicant.full_name))
      redirect_to job_applications_path
    else
      flash[:success] = t('applicants.login_success', name: CGI.escapeHTML(applicant.full_name))
      redirect_after_login admissions_path
    end
  end

private

  def login_applicant(applicant)
    session[:applicant_id] = applicant.id
    session[:member_id] = nil
    cookies[:signed_in] = 1

    invalidate_cached_current_user
  end

  include PendingApplications
end
