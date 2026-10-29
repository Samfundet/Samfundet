# frozen_string_literal: true

require_relative '../../config/initializers/haml_markdown'

RSpec.describe Haml::Filters::Markdown do
  it 'renders Markdown through the direct API used by page content' do
    expect(described_class.render('**bold**')).to include('<strong>bold</strong>')
  end

  it 'uses the configured renderer for static Haml filters' do
    html = Haml::Template.new { ":markdown\n  <script>alert(1)</script>\n  ~~removed~~\n" }.render
    expect(html).to include('<del>removed</del>')
    expect(html).not_to include('<script>')
  end

  it 'renders interpolated Haml filters with the same options' do
    template = Haml::Template.new { ':markdown' + "\n  " + '**#{word}**' + "\n" }
    expect(template.render(Object.new, word: 'dynamic')).to include('<strong>dynamic</strong>')
  end
end
