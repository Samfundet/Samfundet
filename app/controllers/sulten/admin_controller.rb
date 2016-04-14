class Sulten::AdminController < ApplicationController
  filter_access_to [:admin], require: :read

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :manage, :sulten_admin }

  def index
  end

  def admin_applet
  end
end
