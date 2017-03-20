module FeedbackHelper
  def feedback_token
    request.session_options[:id]
  end
end
