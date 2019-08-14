# frozen_string_literal: true

module PendingApplications
  def invalidate_cached_current_user
    @current_user = nil
  end

  def pending_application?
    session[:pending_application]
  end

  def save_pending_application(applicant)

    session[:pending_application] = nil
  end
end
