class SearchController < ApplicationController
  def new
    @search = Search.new
  end

  def create
    search = Search.new(params[:search])

    @results = search.results

    render :results
  end

  def search
    @search = if params[:search]
                Search.new(params[:search])
              else
                Search.new
              end
    @results = @search.results.paginate(page: params[:page], per_page: 10) if @search.query?
  end
end
