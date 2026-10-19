# frozen_string_literal: true

require 'rails_helper'

describe MembersController do
  before do
    user = create(:member)
    user.roles << Role.super_user
    login_member(user)
  end

  describe 'GET #search' do
    before do
      @members = create_list(:member, 5, fornavn: 'Foobar')
    end

    it 'assigns @members' do
      get :search, params: { term: 'Foobar' }, format: :json

      expect(assigns(:members)).to eq @members
    end

    it 'responds with json' do
      get :search, params: { term: 'Foobar' }, format: :json

      expect(response.media_type).to eq('application/json')
    end
  end

  describe 'POST #steal_identity' do
    let(:member) { create(:member) }
    it 'sets the signed-in member identity and clears the applicant identity' do
      applicant = create(:applicant)
      session[:applicant_id] = applicant.id
      post :steal_identity, params: { member_id: member.id }

      expect(session[:member_id]).to eq(member.id)
      expect(session[:applicant_id]).to be_nil
    end

    it 'redirects to root' do
      post :steal_identity, params: { member_id: member.id }

      expect(response).to redirect_to root_path
    end
  end
end

RSpec.describe MembersController, type: :controller do
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'lists relevant control-panel applets' do
    relevant = double(relevant?: true)
    irrelevant = double(relevant?: false)
    allow(ControlPanel).to receive(:applets).and_return([relevant, irrelevant])
    get :control_panel
    expect(assigns(:applets)).to eq([relevant])
    expect(assigns(:wise_words)).to be_present
  end
  it 'lists memberships for a selected member' do
    member = create(:member)
    role = create(:role)
    member.roles << role
    get :show_roles, params: { member_id: member.id }
    expect(assigns(:member)).to eq(member)
    expect(assigns(:roles).map(&:role)).to eq([role])
  end
  it 'handles absent or unknown members in the role browser' do
    get :show_roles
    expect(assigns(:member)).to be_nil
    expect(assigns(:roles)).to be_nil
    get :show_roles, params: { member_id: -1 }
    expect(response).to have_http_status(:ok)
  end
end
