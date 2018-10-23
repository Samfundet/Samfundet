# frozen_string_literal: true

class StaticController < ApplicationController
  # Raise a 404 error if a template is missing
  rescue_from ActionView::MissingTemplate do
    raise ActionController::RoutingError, 'Template not found'
  end

  def show
    render params[:page], layout: false
  end
end
