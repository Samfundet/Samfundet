# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::MenuItemsController, type: :controller do
  let(:record) { create(:sulten_menu_item) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'prepares a new record for the form' do
    get :new
    expect(assigns(:menu_item)).to be_new_record
    expect(response).to render_template('sulten/menu/new_item')
  end
  it 'loads the requested record for editing' do
    get :edit, params: { id: record.id }
    expect(assigns(:menu_item)).to eq(record)
  end
  it 'persists valid submitted attributes' do
    attributes = attributes_for(:sulten_menu_item)
    attributes[:category_id] = create(:sulten_menu_category).id
    expect { post :create, params: { sulten_menu_item: attributes } }.to change(Sulten::MenuItem, :count).by(1)
    expect(response).to redirect_to(sulten_admin_menu_index_path)
  end
  it 'renders errors without persisting an invalid record' do
    attributes = attributes_for(:sulten_menu_item).merge({ title_en: '' })
    attributes[:category_id] = create(:sulten_menu_category).id
    expect { post :create, params: { sulten_menu_item: attributes } }.not_to change(Sulten::MenuItem, :count)
    expect(response).to render_template('sulten/menu/new_item')
  end
  it 'updates saved attributes' do
    patch :update, params: { id: record.id, sulten_menu_item: { title_en: 'Updated' } }
    expect(record.reload.title_en).to eq('Updated')
    expect(response).to redirect_to(sulten_admin_menu_index_path)
  end
  it 'preserves the persisted record on invalid updates' do
    original = record.attributes
    patch :update, params: { id: record.id, sulten_menu_item: { title_en: '' } }
    expect(record.reload.attributes).to eq(original)
    expect(response).to render_template('sulten/menu/new_item')
  end
  it 'deletes the requested record' do
    record
    expect { delete :destroy, params: { id: record.id } }.to change(Sulten::MenuItem, :count).by(-1)
    expect(response).to redirect_to(sulten_admin_menu_index_path)
  end
end
