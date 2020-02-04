# frozen_string_literal: true

class Sulten::AdminController < Sulten::BaseController
  # Custom authorization functionality because there is no associated resource with the controller
  before_action :authorize
  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, Sulten::Reservation }

  def index; end

  def admin_applet; end

private

  def authorize
    # Every action in this controller requires :manage permission on Sulten::Reservation
    authorize! :manage, Sulten::Reservation
  end
end
