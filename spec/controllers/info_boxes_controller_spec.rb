# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InfoBoxesController, type: :controller do
  context 'as a superuser' do
    let(:image) { create(:image) }
    let(:info_box) { create(:info_box, image: image) }

    before do
      member = create(:member)
      member.roles << Role.super_user
      login_member(member)
    end

    it 'lists info boxes in start time order' do
      later = create(:info_box, image: image, start_time: 2.hours.from_now)
      earlier = create(:info_box, image: image, start_time: 1.hour.ago)
      get :index

      expect(response).to render_template(:index)
      expect(assigns(:info_boxes)).to eq([earlier, later])
    end

    it 'shows the requested info box' do
      get :show, params: { id: info_box.id }
      expect(response).to render_template(:show)
      expect(assigns(:info_box)).to eq(info_box)
    end

    it 'creates an info box from valid attributes' do
      attributes = attributes_for(:info_box, image_id: image.id)
      expect { post :create, params: { info_box: attributes } }.to change(InfoBox, :count).by(1)
      expect(assigns(:info_box).title_en).to eq(attributes[:title_en])
      expect(response).to redirect_to(root_path)
    end

    it 'renders the form without saving when required fields are missing' do
      attributes = attributes_for(:info_box, image_id: image.id, title_en: '')
      expect { post :create, params: { info_box: attributes } }.not_to change(InfoBox, :count)
      expect(assigns(:info_box).errors[:title_en]).to be_present
      expect(response).to render_template(:new)
    end

    it 'updates an info box' do
      patch :update, params: { id: info_box.id, info_box: { title_en: 'Updated title' } }
      expect(info_box.reload.title_en).to eq('Updated title')
      expect(response).to redirect_to(root_path)
    end

    it 'preserves saved attributes when an update is invalid' do
      original_title = info_box.title_en
      patch :update, params: { id: info_box.id, info_box: { title_en: '' } }
      expect(info_box.reload.title_en).to eq(original_title)
      expect(response).to render_template(:edit)
    end

    it 'deletes the requested info box' do
      info_box
      expect { delete :destroy, params: { id: info_box.id } }.to change(InfoBox, :count).by(-1)
      expect(response).to redirect_to(root_path)
    end
  end

  context 'as a regular member' do
    it 'denies access to the admin index' do
      login_member(create(:member))
      get :index
      expect(response).to redirect_to(root_path)
      expect(flash[:error]).to eq(I18n.t('common.no_access'))
    end
  end
end
