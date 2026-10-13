# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PageRevision do
  it 'requires a page and a supported content type' do
    revision = described_class.new(content_type: 'unknown')
    expect(revision).not_to be_valid
    expect(revision.errors[:page]).to be_present
    expect(revision.errors[:content_type]).to be_present
    revision.page = Page.new
    %w[html markdown].each do |type|
      revision.content_type = type
      expect(revision).to be_valid
    end
  end
end
