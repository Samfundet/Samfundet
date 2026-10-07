# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AdmissionsAdmin::CampusController, type: :controller do
  let(:campus) { create(:campus) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'lists campuses alphabetically with applicant counts' do
    first = create(:campus, name: 'A')
    last = create(:campus, name: 'Z')
    get :admin
    expect(assigns(:campuses)).to eq([first, last])
    expect(assigns(:campus_count)).to eq(0)
  end
  it 'starts a new campus' do
    get :new
    expect(assigns(:campus)).to be_new_record
  end
  %i[show edit].each do |action|
    it "loads the selected campus for #{action}" do
      get action, params: { id: campus.id }
      expect(assigns(:campus)).to eq(campus)
    end
  end
  it 'creates a campus' do
    expect { post :create, params: { campus: { name: 'New campus' } } }.to change(Campus, :count).by(1)
    expect(response).to redirect_to(action: :admin)
  end
  it 'updates a campus name' do
    patch :update, params: { id: campus.id, campus: { name: 'Changed' } }
    expect(campus.reload.name).to eq('Changed')
    expect(response).to redirect_to(action: :admin)
  end
  it 'deactivates and reactivates campuses' do
    get :deactivate, params: { campus_id: campus.id }
    expect(campus.reload).not_to be_active
    get :activate, params: { campus_id: campus.id }
    expect(campus.reload).to be_active
  end
  it 'deletes the selected campus' do
    campus
    expect { get :destroy, params: { campus_id: campus.id } }.to change(Campus, :count).by(-1)
  end
end
