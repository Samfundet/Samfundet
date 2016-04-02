require 'rails_helper'

describe ApplicantsController do

  describe "GET #new" do
    it "assigns @applicant to a new record" do
      get :new

      expect(assigns(:applicant)).to be_new_record
    end
    it "renders the new template" do
      get :new

      expect(respose).to render_template(:new)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      let(:valid_attributes) { attributes_for(:applicant)}
      it "saves the applicant" do
        expect{
          post :create, applicant: valid_attributes
        }.to change(Applicant, :count).by(1)
      end
      it "logs in the created applicant" do
        post :create, applicant: valid_attributes

        expect(assigns(:applicant)).to eq controller.current_user
      end

      context "with pending application" do
        let(:application) { create(:job_application)}
        it "saves the pending application" do
          post :create, {applicant: valid_attributes} ,{ pending_application: application}

          expect(assigns(:applicant).job_applications).to include(application)
          expect(response).to redirect_to job_applications_path
        end
      end
      context "without pending application" do
        post :create, applicant: valid_attributes

        expect(response).to redirect_to admissions_path
      end
    end
    context "with invalid attributes" do
      let(:invalid_attributes) { attributes_for(:applicant, firstname: '')}
      it "does not save the applicant" do
        expect{
          post :create, applicant: invalid_attributes
        }.to_not change(Applicant, :count)
      end
      it "renders the new template" do
        post :create, applicant: invalid_attributes

        expect(response).to render_template(:new)
      end
    end
  end
end