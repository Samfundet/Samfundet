# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ApplicationHelper, type: :helper do
  before do
    helper.extend(Haml::Helpers)
    helper.init_haml_helpers
  end
  it 'adds noindex metadata to the head' do
    helper.disable_robots
    expect(helper.content_for(:head)).to include('noindex', 'robots')
  end
  it 'renders escaped Open Graph values' do
    helper.set_open_graph_params(title: '<Title>')
    expect(helper.content_for(:open_graph)).to include('og:title', '&lt;Title&gt;')
  end
  it 'renders Twitter metadata' do
    helper.set_twitter_params(card: 'summary')
    expect(helper.content_for(:twitter)).to include('twitter:card', 'summary')
  end
  it 'renders a background image with optional content' do
    image = double('attachment')
    allow(image).to receive(:url).with(:large).and_return('/images/banner.jpg')
    expect(helper.background_image_helper('banner', image, size: :large)).to include('banner', '/images/banner.jpg')
    content = helper.background_image_helper('banner', image, size: :large) { helper.haml_concat('Caption') }
    expect(content).to include('Caption')
  end
end
