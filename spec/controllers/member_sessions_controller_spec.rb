require 'rails_helper'

describe MemberSessionsController do
  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template(:new)
    end

    it "sets redirect path when specified" do
      redirect_to = "/some/redirect/path"
      get :new, params: { redirect_to: redirect_to }
      expect(assigns(:redirect_to)).to eq redirect_to
    end
  end

  describe "POST #create" do
    let(:user) { create(:member, passord: "password") }
    context "when password is valid" do
      it "sets the current user and redirect to root" do
        post(
          :create,
          params: {
            member_login_id: user.mail,
            member_password: "password"
          }
        )

        expect(response).to redirect_to root_path
        expect(controller.current_user).to eq user
      end
    end

    context "when password is unvalid" do
      it "renders the page with error" do
        post(
          :create,
          params: {
            member_login_id: user.mail,
            member_password: "invalid"
          }
        )

        expect(response).to render_template(:new)
        expect(flash[:error]).to match(I18n.t("sessions.login_error"))
      end
    end
  end
end
