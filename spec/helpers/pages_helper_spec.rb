# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesHelper, type: :helper do
  describe '#diff' do
    it 'marks insertions and deletions and preserves unchanged words' do
      expect(helper.diff('old text', 'new text')).to include('<del>old</del>', '<ins>new</ins>', 'text')
      expect(helper.diff(nil, 'added')).to include('<ins>added</ins>')
      expect(helper.diff('removed', nil)).to include('<del>removed</del>')
      expect(helper.diff(nil, nil)).to eq('')
    end

    it 'escapes user HTML in both versions' do
      expect(helper.diff('<script>', '<img>')).not_to include('<script>', '<img>')
    end
  end

  describe '#expand_includes' do
    it 'expands nested includes' do
      allow(Page).to receive(:find_by).with(name: 'first').and_return(double(content: 'Start %include second%'))
      allow(Page).to receive(:find_by).with(name: 'second').and_return(double(content: 'End'))
      expect(helper.expand_includes('%include first%')).to eq('Start End')
    end

    it 'stops circular includes' do
      allow(Page).to receive(:find_by).with(name: 'loop').and_return(double(content: '%include loop%'))
      expect(helper.expand_includes('%include loop%')).to eq(I18n.t('pages.already_included', name: 'loop'))
    end

    it 'reports missing includes' do
      allow(Page).to receive(:find_by).with(name: 'missing').and_return(nil)
      expect(helper.expand_includes('%include missing%')).to eq(I18n.t('pages.include_not_found', name: 'missing'))
    end
  end

  describe '#render_page_content' do
    it 'renders Markdown' do
      expect(helper.render_page_content('**bold**', 'markdown')).to include('<strong>bold</strong>')
    end
    it 'accepts absent Markdown content' do
      expect(helper.render_page_content(nil, 'markdown')).to eq('')
    end
    it 'passes HTML through as safe content' do
      content = helper.render_page_content('<p>Hello</p>', 'html')
      expect(content).to eq('<p>Hello</p>')
      expect(content).to be_html_safe
    end
    it 'reports unsupported content types' do
      expect(helper.render_page_content('text', 'unknown')).to eq(I18n.t('pages.invalid_content_type', content_type: 'unknown'))
    end
  end
end

RSpec.describe PagesHelper, type: :helper do
  it 'generates links from localized and English page names' do
    page = create(:page)
    expect(helper.page_by_name(page.name_en)).to eq(helper.page_url(page))
    expect(helper.page_by_name_en(page.name_en.upcase)).to eq(helper.page_url(page))
  end
  it 'returns a harmless link when a named page does not exist' do
    expect(helper.page_by_name('missing')).to eq('#')
    expect(helper.page_by_name_en('missing')).to eq('#')
  end
end
