# frozen_string_literal: true

class ApplicantSessionsController < UserSessionsController
  skip_authorization_check
  layout 'admissions'

  def new
    @applicant = Applicant.new
    @redirect_to = params[:redirect_to] || request_referer_if_on_current_domain
    @admission = params[:admission]
  end

  def create
    applicant = Applicant.authenticate(params[:applicant_login_field],
                                       params[:applicant_login_password])
    admission = Admission.appliable.find_by_id(params[:admission_id])

    ## Authentication details were incorrect,
    if !applicant
      flash[:error] = t('applicants.login_error')
      redirect_to applicant_login_path
      return
    end

    if !applicant.verified
      flash[:error] = t('applicants.email_verification.login_email_unverified',
                        name: CGI.escapeHTML(applicant.full_name))

      existing_verification_hash = EmailVerification.find_by(applicant_id: applicant.id)

      if existing_verification_hash && existing_verification_hash.count > 10 && existing_verification_hash.updated_at > Time.current - 1.hour
        existing_verification_hash.count += 1
        existing_verification_hash.save!
        flash[:message] = t('applicants.email_verification.too_many')
      else
        send_verification_email(applicant, admission)
      end

      redirect_to applicant_login_path
      return
    else
      login_applicant applicant
    end

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

  def send_verification_email(applicant, admission = nil)
    VerifyEmailApplicantMailer.send_applicant_email_verification(applicant, admission).deliver
    flash[:message] = t('applicants.email_verification.verification_sent',
                        email: CGI.escapeHTML(applicant.email))
  rescue Net::SMTPError
    flash[:error] = t('applicants.email_verification.email_error')
  end

  include PendingApplications
end
