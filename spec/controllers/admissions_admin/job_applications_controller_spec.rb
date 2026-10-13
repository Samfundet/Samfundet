# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionsAdmin::JobApplicationsController, type: :controller do
  let(:admin) { create(:member) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  let(:application) { create(:job_application) }
  let(:ids) { { admission_id: application.job.admission.id, group_id: application.job.group.id, job_id: application.job.id } }
  it 'loads an application with its log history and group applications' do
    get :show, params: ids.merge(id: application.id)
    expect(assigns(:job_application)).to eq(application)
    expect(assigns(:log_entries)).to be_empty
    expect(assigns(:possible_log_entries)).to eq(LogEntry.possible_log_entries)
    expect(assigns(:job_applications_in_group)).to eq([application])
  end
  it 'clears the applicant response status while retaining interview priority' do
    interview = application.find_or_create_interview
    interview.update!(priority: :wanted, applicant_status: :accepted)
    post :reset_status, params: ids.merge(job_application_id: application.id)
    expect(interview.reload.applicant_status).to be_nil
    expect(interview.priority).to eq(:wanted)
  end
  it 'adds a known applicant to the specified job' do
    applicant = create(:applicant)
    application
    expect { post :hidden_create, params: ids.merge(email: applicant.email) }.to change(JobApplication, :count).by(1)
    expect(flash[:success]).to eq(I18n.t('admissions_admin.add_applicant_success'))
  end
  it 'reports unknown applicants without creating an application' do
    application
    expect { post :hidden_create, params: ids.merge(email: 'unknown@example.com') }.not_to change(JobApplication, :count)
    expect(flash[:error]).to eq(I18n.t('admissions_admin.add_applicant_not_found'))
  end
  it 'does not duplicate existing applications' do
    application
    expect { post :hidden_create, params: ids.merge(email: application.applicant.email) }.not_to change(JobApplication, :count)
    expect(flash[:error]).to eq(I18n.t('admissions_admin.add_applicant_error'))
  end
end
