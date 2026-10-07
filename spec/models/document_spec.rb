# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Document do
  it 'defaults publication date to today without overwriting an explicit date' do
    expect(Document.new.publication_date).to eq(Date.current)
    expect(Document.new(publication_date: Date.yesterday).publication_date).to eq(Date.yesterday)
  end
  it 'requires a PDF attachment' do
    document = Document.new
    expect(document).not_to be_valid
    expect(document.errors[:file]).to be_present
  end
  it 'generates a readable URL or falls back to its ID' do
    document = Document.new(id: 4, title: 'Annual Report')
    expect(document.to_param).to eq('4-annual-report')
    document.title = nil
    expect(document.to_param).to eq('4')
  end
end
