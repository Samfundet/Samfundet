# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PagesController, type: :controller do
  let(:page) { create(:page) }
  let(:admin) { create(:member) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  it 'lists only supported venues' do
    supported = create(:area, name: 'Storsalen')
    create(:area, name: 'Outside')
    get :index
    expect(assigns(:areas)).to contain_exactly(supported)
  end
  it 'shows pages by their localized name' do
    get :show, params: { id: page.name_en }
    expect(assigns(:page)).to eq(page)
    expect(assigns(:menu)).to eq(Page.menu)
    expect(assigns(:show_admin)).to be(true)
  end
  it 'shows page revision history' do
    page.update!(content_en: 'Second version')
    get :history, params: { id: page.name_en }
    expect(assigns(:revisions).map(&:version)).to eq([1, 2])
  end
  it 'starts a new page' do
    get :new
    expect(assigns(:page)).to be_new_record
  end
  it 'creates pages and an initial revision' do
    role = create(:role)
    attrs = attributes_for(:page, role_id: role.id)
    expect { post :create, params: { page: attrs } }.to change(Page, :count).by(1)
    expect(assigns(:page).revisions.count).to eq(1)
    expect(response).to redirect_to(assigns(:page))
  end
  it 'rejects invalid slugs' do
    expect { post :create, params: { page: { name_no: 'invalid name', name_en: 'valid', role_id: Role.super_user.id } } }.not_to change(Page, :count)
    expect(response).to render_template(:new)
  end
  it 'loads a page for editing' do
    get :edit, params: { id: page.name_en }
    expect(assigns(:page)).to eq(page)
  end
  it 'updates page content and adds a revision' do
    page
    expect { patch :update, params: { id: page.name_en, page: { content_en: 'Changed' } } }.to change(PageRevision, :count).by(1)
    expect(Page.find(page.id).content_en).to eq('Changed')
  end
  it 'does not persist invalid page updates' do
    original = page.name_en
    patch :update, params: { id: page.name_en, page: { name_en: 'invalid name' } }
    expect(page.reload.name_en).to eq(original)
    expect(response).to render_template(:edit)
  end
  it 'prepares Markdown previews' do
    get :preview, params: { content: '**bold**', content_type: 'markdown' }, xhr: true
    expect(assigns(:content)).to eq('**bold**')
    expect(assigns(:content_type)).to eq('markdown')
  end
  it 'lists pages that can be edited' do
    page
    get :admin
    expect(assigns(:pages)).to include(page)
  end
  it 'deletes a page with its revisions' do
    page
    expect { delete :destroy, params: { id: page.name_en } }.to change(Page, :count).by(-1)
    expect(response).to redirect_to(admin_pages_path)
  end
  it 'builds a graph that excludes image links and unsupported protocols' do
    page.update!(content_no: '[Internal](about) [External](https://example.com) [Mail](mailto:a@example.com) ![Image](picture)')
    get :graph
    expect(assigns(:data)[page.name_en]).to eq(['about', 'https://example.com'])
  end
  it 'switches the page slug when switching language' do
    get :show, params: { id: page.name_en }
    I18n.with_locale(:en) { expect(controller.change_language).to eq(locale: 'no', id: page.name_no) }
    I18n.with_locale(:no) { expect(controller.change_language).to eq(locale: 'en', id: page.name_en) }
  end
  context 'as a page owner' do
    before do
      owner = create(:member)
      owner.roles << page.role
      login_member(owner)
    end
    it 'updates content while preserving protected metadata' do
      patch :update, params: { id: page.name_en, page: { name_en: 'renamed', content_en: 'Owner content' } }
      expect(page.reload.name_en).not_to eq('renamed')
      expect(Page.find(page.id).content_en).to eq('Owner content')
    end
  end
end

RSpec.describe PagesController, type: :controller do
  it 'filters page graph links without accepting unsupported schemes' do
    controller.request = request
    expect(controller.send(:url_filter, 'about')).to eq('about')
    expect(controller.send(:url_filter, 'mailto:a@example.com')).to be_nil
    expect(controller.send(:url_filter, 'https://other.example/path')).to eq('https://other.example/path')
    expect(controller.send(:url_filter, '/not/a/known/route')).to eq('/not/a/known/route')
    expect(controller.send(:url_filter, 'invalid url')).to eq('invalid url')
    expect(controller.send(:url_filter, '/invalid url')).to eq('/invalid url')
    expect(controller.send(:url_filter, page_path(Page.new(name_en: 'about', name_no: 'om')))).to eq('about')
  end
end
