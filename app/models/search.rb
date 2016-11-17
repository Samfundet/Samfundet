# frozen_string_literal: true
class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion
  include ActiveModel::Validations

  attr_accessor :query

  validates :query, presence: true

  def persisted?
    false
  end

  def initialize(params = {})
    @query = params[:query]
  end

  def results
    # RAILS4: Return PgSearch::Document.none when no query
    PgSearch.multisearch(query).where('? >= publish_at', Time.current) if query
  end

  def query?
    !query.nil?
  end
end
