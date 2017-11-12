# frozen_string_literal: true

# UGLY: Need this to circumvent declarative_authorization's automated permission checking for the application in session
require 'declarative_authorization/maintenance'
include Authorization::Maintenance

module PendingApplications
  def invalidate_cached_current_user
    @current_user = nil
    set_current_user_for_model_layer_access_control
  end

  def pending_application?
    session[:pending_application]
  end

  def save_pending_application(applicant)
    without_access_control do
      application = session[:pending_application]
      application.applicant = applicant
      application.save
    end

    session[:pending_application] = nil
  end
end
