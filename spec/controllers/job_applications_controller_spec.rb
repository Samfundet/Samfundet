# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobApplicationsController, type: :controller do
  let(:job) { create(:job) }
  let(:applicant) { create(:applicant, verified: true) }
  let(:application) { create(:job_application, job: job, applicant: applicant) }
  it 'stores a valid guest application for completion after login' do
    expect { post :create, params: { job_application: { job_id: job.id, motivation: 'Interested' } } }.not_to change(JobApplication, :count)
    expect(session[:pending_application].job).to eq(job)
    expect(session[:pending_application].motivation).to eq('Interested')
    expect(response).to render_template('applicant_sessions/new')
  end
  it 'rejects a guest application with no motivation' do
    post :create, params: { job_application: { job_id: job.id, motivation: '' } }
    expect(session[:pending_application]).to be_nil
    expect(response).to redirect_to(job)
  end
  it 'rejects applications after the deadline' do
    job.admission.update!(actual_application_deadline: 1.minute.ago, shown_application_deadline: 2.minutes.ago)
    post :create, params: { job_application: { job_id: job.id, motivation: 'Interested' } }
    expect(response).to redirect_to(job)
    expect(flash[:error]).to eq(I18n.t('job_applications.cannot_apply_after_deadline'))
  end
  it 'handles missing jobs without storing a pending application' do
    post :create, params: { job_application: { job_id: nil, motivation: 'Interested' } }
    expect(response).to redirect_to(admissions_path)
    expect(session[:pending_application]).to be_nil
  end
  context 'signed in as an applicant' do
    before { login_applicant(applicant) }
    it 'persists applications for the signed-in applicant' do
      expect { post :create, params: { job_application: { job_id: job.id, motivation: 'Interested' } } }.to change(JobApplication, :count).by(1)
      expect(assigns(:job_application).applicant).to eq(applicant)
      expect(response).to redirect_to(job_applications_path)
    end
    it 'rejects duplicate applications' do
      application
      expect { post :create, params: { job_application: { job_id: job.id, motivation: 'Again' } } }.not_to change(JobApplication, :count)
      expect(response).to redirect_to(job)
    end
    it 'groups active applications by admission' do
      application
      withdrawn = create(:job_application, applicant: applicant, withdrawn: true)
      get :index
      expect(assigns(:admissions)[job.admission]).to eq([application])
      expect(assigns(:admissions).values.flatten).not_to include(withdrawn)
    end
    it 'restores a withdrawn application when editing its motivation' do
      application.update!(withdrawn: true)
      patch :update, params: { id: application.id, job_application: { motivation: 'Updated' } }
      expect(application.reload.motivation).to eq('Updated')
      expect(application).not_to be_withdrawn
      expect(response).to redirect_to(job_applications_path)
    end
    it 'does not overwrite motivation with invalid text' do
      original = application.motivation
      patch :update, params: { id: application.id, job_application: { motivation: '' } }
      expect(application.reload.motivation).to eq(original)
      expect(response).to redirect_to(job)
    end
    it 'withdraws an application without deleting it' do
      application
      expect { delete :destroy, params: { id: application.id } }.not_to change(JobApplication, :count)
      expect(application.reload).to be_withdrawn
    end
    it 'moves applications up and down in priority order' do
      first = application
      second = create(:job_application, applicant: applicant)
      post :up, params: { id: second.id }
      expect(second.reload.priority).to eq(1)
      post :down, params: { id: second.id }
      expect(second.reload.priority).to eq(2)
      expect(first.reload.priority).to eq(1)
    end
  end
end

RSpec.describe JobApplicationsController, type: :controller do
  it 'does not change priorities after the user deadline' do
    applicant = create(:applicant)
    login_applicant(applicant)
    application = create(:job_application, applicant: applicant)
    travel_to(application.job.admission.user_priority_deadline + 1.second) do
      post :up, params: { id: application.id }
      expect(application.reload.priority).to eq(1)
      expect(flash[:error]).to eq(I18n.t('job_applications.cannot_prioritize_after_deadline'))
    end
  end
  it 'reports expired deadlines to AJAX clients without changing priorities' do
    applicant = create(:applicant)
    login_applicant(applicant)
    application = create(:job_application, applicant: applicant)
    travel_to(application.job.admission.user_priority_deadline + 1.second) do
      post :down, params: { id: application.id }, xhr: true
      expect(response).to have_http_status(:internal_server_error)
      expect(response.body).to include(I18n.t('job_applications.cannot_prioritize_after_deadline'))
    end
  end
end
