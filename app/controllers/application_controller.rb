# -*- encoding : utf-8 -*-
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  filter_access_to :all

  before_filter :store_location
  before_filter :set_locale
  before_filter :set_current_user_for_model_layer_access_control

  # Helper methods that are also used in controllers
  helper_method :current_user, :logged_in?

  def handle_unverified_request
    raise ActionController::InvalidAuthenticityToken
  end

  rescue_from ActionController::InvalidAuthenticityToken do
    reset_session
    flash[:error] = "There was an error processing your request. Please try again."
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
    begin
      if session[:member_id]
        @current_user ||= Member.find(session[:member_id])
      elsif session[:applicant_id]
        @current_user ||= Applicant.find(session[:applicant_id])
      end
    rescue
      @current_user = nil
    end
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
      else # POST, PUT, DELETE
        unless request.referer.nil?
          redirect_to login_path(redirect_to: request_referer_if_on_current_domain)
        else
          redirect_to root_path
        end
      end
    end
  end

  protected

  # Allows models to access the current user
  def set_current_user_for_model_layer_access_control
    Authorization.current_user = current_user
  end

  def redirect_to_if_not_ajax_request(path)
    if request.xhr?
      render nothing: true
    else
      redirect_to path
    end
  end

  def request_referer_if_on_current_domain
    if request.referer && request.referer.include?(request.host)
      request.referer
    end
  end

  def redirect_back
    redirect_to session[:return_to]
  end
end
