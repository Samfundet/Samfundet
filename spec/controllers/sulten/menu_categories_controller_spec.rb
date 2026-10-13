# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::MenuCategoriesController, type: :controller do
  let(:record) { create(:sulten_menu_category) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'prepares a new record for the form' do
    get :new
    expect(assigns(:menu_category)).to be_new_record
    expect(response).to render_template('sulten/menu/new_category')
  end
  it 'loads the requested record for editing' do
    get :edit, params: { id: record.id }
    expect(assigns(:menu_category)).to eq(record)
  end
  it 'persists valid submitted attributes' do
    attributes = attributes_for(:sulten_menu_category)

    expect { post :create, params: { sulten_menu_category: attributes } }.to change(Sulten::MenuCategory, :count).by(1)
    expect(response).to redirect_to(sulten_admin_menu_index_path)
  end
  it 'renders errors without persisting an invalid record' do
    attributes = attributes_for(:sulten_menu_category).merge({ title_en: '' })

    expect { post :create, params: { sulten_menu_category: attributes } }.not_to change(Sulten::MenuCategory, :count)
    expect(response).to render_template('sulten/menu/new_category')
  end
  it 'updates saved attributes' do
    patch :update, params: { id: record.id, sulten_menu_category: { title_en: 'Updated' } }
    expect(record.reload.title_en).to eq('Updated')
    expect(response).to redirect_to(sulten_admin_menu_index_path)
  end
  it 'preserves the persisted record on invalid updates' do
    original = record.attributes
    patch :update, params: { id: record.id, sulten_menu_category: { title_en: '' } }
    expect(record.reload.attributes).to eq(original)
    expect(response).to render_template('sulten/menu/edit_category')
  end
  it 'deletes the requested record' do
    record
    expect { delete :destroy, params: { id: record.id } }.to change(Sulten::MenuCategory, :count).by(-1)
    expect(response).to redirect_to(sulten_admin_menu_index_path)
  end
end
