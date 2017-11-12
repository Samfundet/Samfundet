# frozen_string_literal: true

require 'rails_helper'

describe ApplicantsController do
  describe 'GET #new' do
    it 'assigns @applicant to a new record' do
      get :new

      expect(assigns(:applicant)).to be_new_record
    end
    it 'renders the new template' do
      get :new

      expect(response).to render_template(:new)
    end
  end

  describe 'POST #create' do
    context 'with valid attributes' do
      let(:campus) { create(:campus) }
      let(:valid_attributes) { attributes_for(:applicant, campus_id: campus.id) }
      it 'saves the applicant' do
        expect do
          post :create, params: { applicant: valid_attributes }
        end.to change(Applicant, :count).by(1)
      end
      it 'logs in the created applicant' do
        post :create, params: { applicant: valid_attributes }

        expect(assigns(:applicant)).to eq controller.current_user
      end

      context 'with pending application' do
        let(:application) { create(:job_application) }
        it 'saves the pending application' do
          post :create, params: { applicant: valid_attributes }, session: { pending_application: application }

          expect(assigns(:applicant).job_applications).to include(application)
          expect(response).to redirect_to job_applications_path
        end
      end
      context 'without pending application' do
        it 'redirects to admissions path' do
          post :create, params: { applicant: valid_attributes }

          expect(response).to redirect_to admissions_path
        end
      end
    end
    context 'with invalid attributes' do
      let(:invalid_attributes) { attributes_for(:applicant, firstname: '') }
      it 'does not save the applicant' do
        expect do
          post :create, params: { applicant: invalid_attributes }
        end.to_not change(Applicant, :count)
      end
      it 'renders the new template' do
        post :create, params: { applicant: invalid_attributes }

        expect(response).to render_template(:new)
      end
    end
  end

  describe 'POST #update' do
    let(:applicant) { create(:applicant) }
    before do
      login_applicant(applicant)
    end
    context 'with valid attributes' do
      let(:valid_attributes) { attributes_for(:applicant, firstname: 'Foo', surname: 'Bar', password: '', password_confirmation: '') }
      let(:valid_attributes_with_pw) { attributes_for(:applicant, old_password: 'password', password: 'Foobar', password_confirmation: 'Foobar') }
      it 'updates the applicant' do
        post :update, params: { id: applicant.id, applicant: valid_attributes }
        applicant.reload

        expect(applicant.firstname).to eq 'Foo'
        expect(applicant.surname).to eq 'Bar'
      end

      it 'displays flash success' do
        post :update, params: { id: applicant.id, applicant: valid_attributes }

        expect(flash[:success]).to match(I18n.t('applicants.update_success'))
      end

      it 'redirects to job applications path' do
        post :update, params: { id: applicant.id, applicant: valid_attributes }

        expect(response).to redirect_to job_applications_path
      end

      it 'changes password' do
        post :update, params: { id: applicant.id, applicant: valid_attributes_with_pw }

        applicant.reload

        expect(Applicant.authenticate(applicant.email, 'password')).to eq nil
        expect(Applicant.authenticate(applicant.email, 'Foobar')).to eq applicant
      end
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) { attributes_for(:applicant, firstname: ' ', password: nil, password_confirmation: nil) }
      let(:invalid_attributes_with_pw) { attributes_for(:applicant, old_password: 'wrongPassword', password: 'Foobar', password_confirmation: 'Foobar') }

      it 'does not update attributes' do
        post :update, params: { id: applicant.id, applicant: invalid_attributes }

        applicant.reload

        expect(applicant.firstname).to eq 'Test'
      end

      it 'renders the edit template' do
        post :update, params: { id: applicant.id, applicant: invalid_attributes }

        expect(response).to render_template(:edit)
      end

      it 'displays flash error' do
        post :update, params: { id: applicant.id, applicant: invalid_attributes }

        expect(flash[:error]).to match(I18n.t('applicants.update_error'))
      end

      context 'when wrong old password submitted' do
        it 'renders edit' do
          post :update, params: { id: applicant.id, applicant: invalid_attributes_with_pw }

          expect(response).to render_template :edit
        end

        it 'displays flash error' do
          post :update, params: { id: applicant.id, applicant: invalid_attributes_with_pw }

          expect(flash[:error]).to match(I18n.t('applicants.update_error'))
        end

        it 'adds error to old_password field' do
          post :update, params: { id: applicant.id, applicant: invalid_attributes_with_pw }

          expect(assigns(:applicant).errors[:old_password]).to include(I18n.t('applicants.password_missmatch'))
        end
      end
    end
  end
end
