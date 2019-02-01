# frozen_string_literal: true

class Sulten::AdminController < ApplicationController
  load_and_authorize_resource only: [:admin]

  has_control_panel_applet :admin_applet,
                           if: -> { can? :manage, :sulten_admin }

  def index; end

  def admin_applet; end
end
