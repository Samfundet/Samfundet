# frozen_string_literal: true

class GraphqlController < ApplicationController
  skip_authorization_check
  skip_before_action :verify_authenticity_token
  after_action :allow_cors

  def allow_cors
    response.set_header('Access-Control-Allow-Origin', '*')

    # Hacky, but required to not make web browser angry
    response.set_header('Access-Control-Allow-Headers', 'Content-Type')
  end

  def handle_options_request
    head(:ok) if request.request_method == 'OPTIONS'
  end

  def execute
    variables = ensure_hash(params[:variables])
    query = params[:query]
    operation_name = params[:operationName]
    context = {
      # Query context goes here, for example:
      # current_user: current_user,
    }
    result = SamfundetSchema.execute(query, variables: variables, context: context, operation_name: operation_name)
    render json: result
  rescue => e
    raise e unless Rails.env.development?
    handle_error_in_development e
  end

  private

  # Handle form data, JSON body, or a blank value
  def ensure_hash(ambiguous_param)
    case ambiguous_param
    when String
      if ambiguous_param.present?
        ensure_hash(JSON.parse(ambiguous_param))
      else
        {}
      end
    when Hash, ActionController::Parameters
      ambiguous_param
    when nil
      {}
    else
      raise ArgumentError, "Unexpected parameter: #{ambiguous_param}"
    end
  end

  def handle_error_in_development(e)
    logger.error e.message
    logger.error e.backtrace.join("\n")

    render json: { error: { message: e.message, backtrace: e.backtrace }, data: {} }, status: 500
  end
end
