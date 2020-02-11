class Sulten::SultenController < ApplicationController
  skip_authorization_check
  layout "full_page"

  def index
    @opening_hours = Area.find_by_name("Lyche").standard_hours
  end

end
