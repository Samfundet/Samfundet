# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ImagesController, type: :controller do
  let(:image) { create(:image) }
  let(:member) { create(:member) }
  before do
    member.roles << Role.super_user
    login_member(member)
  end
  it 'paginates images and tags' do
    image
    tag = Tag.create!(name: 'music')
    get :index
    expect(assigns(:images)).to contain_exactly(image)
    expect(assigns(:tags)).to contain_exactly(tag)
  end
  %i[new show edit].each do |action|
    it "prepares the image for #{action}" do
      get action, params: { id: image.id }
      expect(response).to render_template(action)
    end
  end
  it 'creates an uploaded image and records the current member as uploader' do
    attrs = attributes_for(:image)
    expect { post :create, params: { image: attrs } }.to change(Image, :count).by(1)
    expect(assigns(:image).uploader).to eq(member)
    expect(response).to redirect_to(assigns(:image))
  end
  it 'rejects missing uploads' do
    expect { post :create, params: { image: { title: 'Missing file' } } }.not_to change(Image, :count)
    expect(response).to render_template(:new)
  end
  it 'updates image titles and tags' do
    patch :update, params: { id: image.id, image: { title: 'Updated', tagstring: 'Music, Concert' } }
    expect(image.reload.title).to eq('Updated')
    expect(image.tags.pluck(:name)).to contain_exactly('music', 'concert')
  end
  it 'preserves the title when an update is invalid' do
    title = image.title
    patch :update, params: { id: image.id, image: { title: '' } }
    expect(image.reload.title).to eq(title)
    expect(response).to render_template(:edit)
  end
  it 'deletes an image' do
    image
    expect { delete :destroy, params: { id: image.id } }.to change(Image, :count).by(-1)
    expect(response).to redirect_to(images_path)
  end
  it 'returns all images for an empty search' do
    image
    get :search, params: { search: '' }
    expect(assigns(:images)).to contain_exactly(image)
  end
  it 'renders the image list partial for AJAX searches' do
    image
    get :search, params: { search: '' }, xhr: true
    expect(response).to render_template('_image_list')
  end
end
