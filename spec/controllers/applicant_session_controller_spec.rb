# frozen_string_literal: true

require 'rails_helper'

describe ApplicantSessionsController do
  describe 'GET #new' do
    it 'renders the new template' do
      get :new
      expect(response).to render_template(:new)
    end

    it 'sets redirect path when specified' do
      redirect_to = '/some/redirect/path'
      get :new, params: { redirect_to: redirect_to }
      expect(assigns(:redirect_to)).to eq redirect_to
    end
  end

  describe 'POST #create' do
    let(:user) { create(:applicant, password: 'password', verified: true) }
    context 'when password is valid' do
      it 'sets the current user and redirect to admissions path' do
        post(
          :create,
          params: {
            applicant_login_field: user.email,
            applicant_login_password: 'password'
          }
        )

        expect(response).to redirect_to admissions_path
        expect(controller.current_user).to eq user
      end
    end

    context 'when password is valid and has pending application' do
      it 'sets the current user and redirect to job application path' do
        application = create(:job_application)
        post(
          :create,
          params: {
            applicant_login_field: user.email,
            applicant_login_password: 'password'
          },
          session: {
            pending_application: application
          }
        )

        expect(response).to redirect_to job_applications_path
        expect(controller.current_user).to eq user
        expect(application.reload.applicant).to eq(user)
        expect(session[:pending_application]).to be_nil
      end
    end

    context 'when password is invalid' do
      it 'redirects to login with an error without signing in' do
        post(
          :create,
          params: {
            applicant_login_field: user.email,
            applicant_login_password: 'invalid'
          }
        )
        expect(response).to redirect_to applicant_login_path
        expect(controller.current_user).to be_nil
        expect(flash[:error]).to match(I18n.t('applicants.login_error'))
      end
    end

    context 'when the applicant has not verified their email' do
      let(:user) { create(:applicant, password: 'password', verified: false) }

      it 'sends a verification email and redirects to login without signing in' do
        user
        expect do
          post :create, params: {
            applicant_login_field: user.email,
            applicant_login_password: 'password'
          }
        end.to change { ActionMailer::Base.deliveries.count }.by(1)

        expect(response).to redirect_to applicant_login_path
        expect(controller.current_user).to be_nil
        expect(user.reload).not_to be_verified
        expect(ActionMailer::Base.deliveries.last.to).to eq([user.email])
        expect(user.email_verification).to be_present
        expect(flash[:error]).to eq(I18n.t('applicants.email_verification.login_email_unverified', name: user.full_name))
      end
    end
  end
end
