# frozen_string_literal: true

require 'rails_helper'
RSpec.describe 'custom validators' do
  let(:record_class) do
    Class.new do
      include ActiveModel::Model
      attr_accessor :email, :color, :url
      validates :email, email: true
      validates :color, css_hex_color: true
      validates :url, url: true
      def self.name
        'ValidationRecord'
      end
    end
  end
  it 'accepts valid email, CSS colors and absolute URLs' do
    expect(record_class.new(email: 'ola@example.com', color: '#aBc123', url: 'https://example.com/path')).to be_valid
    expect(record_class.new(email: 'ola@example.com', color: '#abc', url: 'https://example.com')).to be_valid
  end
  it 'rejects blank and malformed inputs' do
    record = record_class.new(email: 'invalid', color: '#12', url: 'not a url')
    expect(record).not_to be_valid
    %i[email color url].each { |field| expect(record.errors[field]).to be_present }
    expect(record_class.new).not_to be_valid
  end
end
