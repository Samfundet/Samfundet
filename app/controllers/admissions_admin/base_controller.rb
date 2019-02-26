# frozen_string_literal: true

# This controller is inherited into all AdmissionsAdmin controllers
class AdmissionsAdmin::BaseController < ApplicationController
  # The purpose of overriding current_ability is that we can use a separate ability-class
  # for controllers in the AdmissionsAdmin namespace
  def current_ability
    @current_ability = AdmissionsAdminAbility.new(current_user)
  end
end
