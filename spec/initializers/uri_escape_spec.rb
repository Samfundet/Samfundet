# frozen_string_literal: true

require 'spec_helper'
require_relative '../../config/initializers/uri_escape'

RSpec.describe 'URI.escape compatibility' do
  it 'escapes spaces and Unicode as UTF-8 bytes' do
    expect(URI.escape('https://samfundet.no/blå sal')).to eq('https://samfundet.no/bl%C3%A5%20sal')
  end

  it 'preserves path and query separators' do
    url = 'https://samfundet.no/events?q=concert&lang=no'
    expect(URI.escape(url)).to eq(url)
  end

  it 'retains the legacy behavior of escaping percent signs and fragment markers' do
    expect(URI.escape('concert%20night#tickets')).to eq('concert%2520night%23tickets')
  end

  it 'escapes characters that cannot appear literally in a URL' do
    expect(URI.escape('https://samfundet.no/<event>"')).to eq('https://samfundet.no/%3Cevent%3E%22')
  end
end
