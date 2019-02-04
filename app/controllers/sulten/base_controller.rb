# frozen_string_literal: true

# This controller is inherited into all Sulten controllers
class Sulten::BaseController < ApplicationController

  # The purpose of overriding current_ability is that we can use a separate ability-class
  # for controllers in the Sulten namespace
  def current_ability
    @current_ability = SultenAbility.new(current_user)
  end
end
