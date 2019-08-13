# frozen_string_literal: true

module PendingApplications
  def invalidate_cached_current_user
    @current_user = nil
  end

  def pending_application?
    cookies[:pending_application]
  end

  def save_pending_application(applicant)
    application = JobApplication.new
    application_json = cookies[:pending_application]
    application.from_json(application_json)
    application.applicant = applicant
    application.save

    session[:pending_application] = nil
  end
end
