# frozen_string_literal: true

# Temporary controller for lyche 'under_construction' page
class Sulten::LycheController < Sulten::BaseController
  skip_authorization_check
  layout 'lyche'

  def under_construction
  end
end
