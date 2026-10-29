# frozen_string_literal: true

class SearchController < ApplicationController
  # Searching functionality is publicly available
  skip_authorization_check

  def search
    @search = case params[:search]
              when ActionController::Parameters
                Search.new(query: params[:search][:query])
              when String
                # Allow plain links such as /search?search=foo
                Search.new(query: params[:search])
              else
                Search.new
              end
    @results = @search.results.paginate(page: params[:page], per_page: 10) if @search.query?
  end
end
