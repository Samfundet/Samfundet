# frozen_string_literal: true

require 'rails_helper'
RSpec.describe SearchController, type: :controller do
  it 'shows the search form without results before a query is submitted' do
    get :search
    expect(assigns(:search).query).to be_nil
    expect(assigns(:results)).to be_nil
    expect(response).to render_template(:search)
  end
  it 'paginates published search results' do
    results = double('search result relation')
    allow(PgSearch).to receive(:multisearch).with('concert').and_return(results)
    allow(results).to receive(:where).and_return(results)
    expect(results).to receive(:paginate).with(page: '2', per_page: 10).and_return([])
    get :search, params: { search: { query: 'concert' }, page: 2 }
    expect(assigns(:search).query).to eq('concert')
    expect(assigns(:results)).to eq([])
  end
end
