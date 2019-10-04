# frozen_string_literal: true

# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # CanCan lockdown. Check auth for all controllers unless explicitly skipped
  check_authorization

  rescue_from CanCan::AccessDenied do |exception|
    Rails.logger.debug "Access denied on #{exception.action} #{exception.subject.inspect}"
    permission_denied
  end

  before_action :store_location
  before_action :set_locale

  # Helper methods that are also used in controllers
  helper_method :current_user, :logged_in?

  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    reset_session
    flash[:error] = 'There was an error processing your request. Please try again.'
    redirect_to root_path
  end

  extend ControlPanel::ControllerHelpers

  def store_location
    session[:return_to] = request.url if request.get?
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def current_user
    if session[:member_id]
      @current_user ||= Member.find(session[:member_id])
    elsif session[:applicant_id]
      @current_user ||= Applicant.find(session[:applicant_id])
    end
  rescue ActiveRecord::RecordNotFound
    @current_user = nil
  end

  def logged_in?
    !current_user.nil?
  end

  def permission_denied
    if request.xhr?
      render nothing: true, status: 401
    else
      flash[:error] = t('common.log_in_to_view_page')
      if request.get? # Regular GET
        redirect_to login_path(redirect_to: request.path)
      elsif request.referer.nil?
        redirect_to root_path
      else
        redirect_to login_path(redirect_to: request_referer_if_on_current_domain)
      end
    end
  end

  protected

  def redirect_to_if_not_ajax_request(path)
    if request.xhr?
      render body: nil
    else
      redirect_to path
    end
  end

  def request_referer_if_on_current_domain
    request.referer if request.referer&.include?(request.host)
  end

  def redirect_back
    redirect_to session[:return_to]
  end
end
