# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Search do
  it 'requires a nonblank query' do
    [nil, '', ' '].each { |query| expect(described_class.new(query: query)).not_to be_valid }
    expect(described_class.new(query: 'concert')).to be_valid
  end

  it 'is never a persisted record' do
    expect(described_class.new).not_to be_persisted
  end

  it 'does not search when the query is absent' do
    search = described_class.new
    expect(search.query?).to be(false)
    expect(PgSearch).not_to receive(:multisearch)
    expect(search.results).to be_nil
  end

  it 'restricts search results to published documents' do
    search = described_class.new(query: 'concert')
    relation = double('search results')
    allow(PgSearch).to receive(:multisearch).with('concert').and_return(relation)
    expect(relation).to receive(:where).with('? >= publish_at', kind_of(ActiveSupport::TimeWithZone)).and_return(:published_results)
    expect(search.query?).to be(true)
    expect(search.results).to eq(:published_results)
  end
end
