# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Page do
  let(:role) { create(:role) }
  let(:page) { described_class.create!(name_no: 'om-oss', name_en: 'about-us', role: role, title_no: 'Om oss', title_en: 'About us', content_no: 'Innhold', content_en: 'Content') }

  it 'normalizes page names and looks them up in the active locale' do
    page.update!(name_no: 'OM-OSS', name_en: 'ABOUT-US')
    expect(page.reload.name_no).to eq('om-oss')
    I18n.with_locale(:no) { expect(Page.find_by_name('OM-OSS')).to eq(page) }
    I18n.with_locale(:en) { expect(Page.find_by_name('ABOUT-US')).to eq(page) }
  end

  it 'looks up pages by numeric ID or localized name' do
    expect(Page.find_by_param(page.id.to_s)).to eq(page)
    expect(Page.find_by_param('about-us')).to eq(page)
    expect(page.to_param).to eq('about-us')
  end

  it 'creates a revision for changed content and preserves earlier revisions' do
    original = page.revisions.first
    expect(original.version).to eq(1)
    expect { page.update!(content_en: 'New content') }.to change(PageRevision, :count).by(1)
    expect(page.reload.content_en).to eq('New content')
    expect(original.reload.content_en).to eq('Content')
    expect(page.revisions.last.version).to eq(2)
    expect { page.update!(content_en: 'New content') }.not_to change(PageRevision, :count)
  end

  it 'rejects duplicate names and invalid slugs' do
    page
    expect(Page.new(name_no: 'om-oss', name_en: 'other', role: role)).not_to be_valid
    expect(Page.new(name_no: 'bad name', name_en: 'other', role: role)).not_to be_valid
  end

  %i[index menu tickets handicap_info].each do |method|
    it "creates the #{method} system page once" do
      system_page = described_class.public_send(method)
      expect(system_page).to be_persisted
      expect(system_page.role).to eq(Role.super_user)
      expect { expect(described_class.public_send(method)).to eq(system_page) }.not_to change(Page, :count)
    end
  end

  it 'deletes revisions when the page is deleted' do
    page
    expect { page.destroy! }.to change(PageRevision, :count).by(-1)
  end
end
