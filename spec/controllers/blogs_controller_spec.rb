# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BlogsController, type: :controller do
  let(:member) { create(:member) }
  let(:image) { create(:image) }
  let(:article) { create(:blog, author: member, image: image) }
  before do
    member.roles << Role.super_user
    login_member(member)
  end
  it 'lists only published articles with publication times in the past' do
    visible = create(:blog, author: member, image: image, published: true, publish_at: 1.day.ago)
    create(:blog, author: member, image: image, published: true, publish_at: 1.day.from_now)
    create(:blog, author: member, image: image, published: false, publish_at: 1.day.ago)
    get :index
    expect(assigns(:articles)).to contain_exactly(visible)
  end
  %i[show edit].each do |action|
    it "loads the requested article for #{action}" do
      get action, params: { id: article.id }
      expect(assigns(:article)).to eq(article)
      expect(response).to render_template(action)
    end
  end
  it 'starts a new article' do
    get :new
    expect(assigns(:article)).to be_new_record
  end
  it 'creates articles with the current member as author' do
    attrs = attributes_for(:blog, image_id: image.id)
    expect { post :create, params: { blog: attrs } }.to change(Blog, :count).by(1)
    expect(assigns(:article).author).to eq(member)
    expect(response).to redirect_to(assigns(:article))
  end
  it 'rejects incomplete articles' do
    expect { post :create, params: { blog: { title_en: '' } } }.not_to change(Blog, :count)
    expect(response).to render_template(:new)
  end
  it 'updates valid article content' do
    patch :update, params: { id: article.id, blog: { title_en: 'Changed title' } }
    expect(article.reload.title_en).to eq('Changed title')
    expect(response).to redirect_to(article)
  end
  it 'preserves content when an update is invalid' do
    title = article.title_en
    patch :update, params: { id: article.id, blog: { title_en: '' } }
    expect(article.reload.title_en).to eq(title)
    expect(response).to render_template(:edit)
  end
  it 'deletes an article' do
    article
    expect { delete :destroy, params: { id: article.id } }.to change(Blog, :count).by(-1)
    expect(response).to redirect_to(blogs_path)
  end
  it 'lists unpublished articles in administration' do
    article
    get :admin
    expect(assigns(:articles)).to contain_exactly(article)
  end
end
