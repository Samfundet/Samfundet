# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionsAdmin::GroupsController, type: :controller do
  let(:admin) { create(:member) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  let(:job) { create(:job) }
  let(:admission) { job.admission }
  let(:group) { job.group }
  it 'counts jobs, applicants and applications within the admission' do
    create(:job_application, job: job)
    get :show, params: { admission_id: admission.id, id: group.id }
    expect(assigns(:n_jobs)).to eq(1)
    expect(assigns(:n_applicants)).to eq(1)
    expect(assigns(:n_applications)).to eq(1)
    expect(assigns(:jobs)).to contain_exactly(job)
    expect(assigns(:applications_per_day).map(&:last).sum).to eq(1)
    expect(assigns(:should_show_delete_button)).to be(false)
  end
  it 'groups active applications by applicant name' do
    application = create(:job_application, job: job)
    create(:job_application, job: job, withdrawn: true)
    get :applications, params: { admission_id: admission.id, id: group.id }
    expect(assigns(:job_application_groupings)).to eq([[application]])
  end
  it 'exports application groups as CSV' do
    job
    get :applications, params: { admission_id: admission.id, id: group.id }, format: :csv
    expect(response.headers['Content-Disposition']).to include('.csv')
  end
  it 'lists applicants missing an interview for their highest-priority job' do
    application = create(:job_application, job: job)
    application.find_or_create_interview
    get :show_applicants_with_missing_interviews, params: { admission_id: admission.id, group_id: group.id }
    expect(assigns(:top_job_applications).first[1]).to eq(application)
  end
  it 'lists unwanted applicants to call in alphabetical order' do
    get :reject_calls, params: { admission_id: admission.id, id: group.id }
    expect(assigns(:applicants_to_call)).to eq([])
  end
end
