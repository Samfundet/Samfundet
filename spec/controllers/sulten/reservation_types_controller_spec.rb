# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Sulten::ReservationTypesController, type: :controller do
  let(:type) { create(:sulten_reservation_type) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'lists available reservation types' do
    type
    get :index
    expect(assigns(:types)).to eq([type])
  end
  %i[show edit].each do |action|
    it "loads the selected type for #{action}" do
      get action, params: { id: type.id }
      expect(assigns(:type)).to eq(type)
    end
  end
  it 'starts a new type' do
    get :new
    expect(assigns(:type)).to be_new_record
  end
  it 'creates and updates reservation types' do
    expect { post :create, params: { sulten_reservation_type: { name: 'Food', description: 'Dinner' } } }.to change(Sulten::ReservationType, :count).by(1)
    record = assigns(:type)
    expect(response).to redirect_to(record)
    patch :update, params: { id: record.id, sulten_reservation_type: { name: 'Drinks' } }
    expect(record.reload.name).to eq('Drinks')
    expect(response).to redirect_to(sulten_reservation_types_path)
  end
  it 'deletes the selected reservation type' do
    type
    expect { delete :destroy, params: { id: type.id } }.to change(Sulten::ReservationType, :count).by(-1)
  end
end
