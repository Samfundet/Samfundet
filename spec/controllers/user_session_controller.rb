require 'rails_helper'

describe UserSessionsController do
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "sets redirect path when specified" do
      redirect_to = "/some/redirect/path"
      get :new, redirect_to: redirect_to
      expect(assigns(:redirect_to)).to eq redirect_to
    end
  end

  describe "GET #destroy" do
    let(:applicant) { create(:applicant) }
    let(:user) { create(:member) }

    context "logged in as member" do
      before do
        login_member(user)
      end

      it "logs out the member" do
        post :destroy
        expect(session[:member_id]).to be_nil
      end
    end

    context "logged in as a applicant" do
      before do
        login_applicant(applicant)
      end

      it "logs out the applicant" do
        post :destroy
        expect(session[:applicant_id]).to be_nil
      end
    end
  end
end
