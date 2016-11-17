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
    let(:user) { create(:applicant, password: 'password') }
    context 'when password is valid' do
      it 'sets the current user and redirect to admissions path' do
        post(
          :create,
          params: {
            applicant_login_email: user.email,
            applicant_login_password: 'password'
          }
        )

        expect(response).to redirect_to admissions_path
        expect(controller.current_user).to eq user
      end
    end

    context 'when password is valid and has pending application' do
      it 'sets the current user and redirect to job application path' do
        application = create(:job_application, applicant: user)
        post(
          :create,
          params: {
            applicant_login_email: user.email,
            applicant_login_password: 'password'
          },
          session: {
            pending_application: application
          }
        )

        expect(response).to redirect_to job_applications_path
        expect(controller.current_user).to eq user
        expect(user.job_applications).to include(application)
      end
    end

    context 'when password is unvalid' do
      it 'renders the page with error' do
        post(
          :create,
          params: {
            applicant_login_email: user.email,
            applicant_login_password: 'invalid'
          }
        )
        expect(response).to render_template(:new)
        expect(flash[:error]).to match(I18n.t('applicants.login_error'))
      end
    end
  end
end
