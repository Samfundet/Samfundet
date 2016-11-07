require 'rails_helper'

describe MembersController do
  before do
    user = create(:member)
    user.roles << Role.super_user
    login_member(user)
  end

  describe "GET #search" do
    before do
     @members = create_list(:member, 5, fornavn: "Foobar")
    end

    it "assigns @members" do
      get :search, params: { term: "Foobar" }, format: :json

      expect(assigns(:members)).to eq @members
    end

    it "responds with json" do
      get :search, params: { term: "Foobar" }, format: :json

      expect(response.content_type).to eq("application/json")
    end
  end

  describe "POST #steal_identity" do
    let(:member) {create(:member)}
    xit "changes current user to the given member" do
      post :steal_identity, params: { member_id: member.id }

      expect(controller.current_user).to eq member
    end

    it "redirects to root" do
      post :steal_identity, params: { member_id: member.id }

      expect(response).to redirect_to root_path
    end
  end
end
