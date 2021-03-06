# frozen_string_literal: true

class SearchController < ApplicationController
  # Searching functionality is publicly available
  skip_authorization_check

  def search
    @search = if params[:search]
                Search.new(params[:search])
              else
                Search.new
              end
    @results = @search.results.paginate(page: params[:page], per_page: 10) if @search.query?
  end
end
