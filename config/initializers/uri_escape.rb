# frozen_string_literal: true

require 'uri'

module URI
  def self.escape(url)
    URI::DEFAULT_PARSER.escape(url)
  end
end