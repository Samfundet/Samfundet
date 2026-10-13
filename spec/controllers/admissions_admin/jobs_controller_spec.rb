# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionsAdmin::JobsController, type: :controller do
  let(:admin) { create(:member) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  let(:job) { create(:job) }
  let(:admission) { job.admission }
  let(:group) { job.group }
  let(:ids) { { admission_id: admission.id, group_id: group.id, id: job.id } }
  %i[show edit].each do |action|
    it "loads the requested job for #{action}" do
      get action, params: ids
      expect(assigns(:job)).to eq(job)
    end
  end
  it 'prepares a job in the selected admission and group' do
    get :new, params: ids.except(:id)
    expect(assigns(:job)).to be_new_record
    expect(assigns(:job).admission).to eq(admission)
    expect(assigns(:job).group).to eq(group)
  end
  it 'creates a job with permitted attributes' do
    attributes = attributes_for(:job)
    job
    expect { post :create, params: ids.except(:id).merge(job: attributes) }.to change(Job, :count).by(1)
    expect(response).to redirect_to(admissions_admin_admission_group_path(admission, group))
  end
  it 'rejects incomplete jobs' do
    job
    expect { post :create, params: ids.except(:id).merge(job: { title_no: '' }) }.not_to change(Job, :count)
    expect(response).to render_template(:new)
  end
  it 'updates a job title' do
    patch :update, params: ids.merge(job: { title_no: 'Updated' })
    expect(job.reload.title_no).to eq('Updated')
  end
  it 'preserves a job when updates are invalid' do
    title = job.title_no
    patch :update, params: ids.merge(job: { title_no: '' })
    expect(job.reload.title_no).to eq(title)
    expect(response).to render_template(:edit)
  end
  it 'deletes a job' do
    job
    expect { delete :destroy, params: ids }.to change(Job, :count).by(-1)
  end
  it 'searches only within the selected group' do
    job.update!(title_no: 'Special job')
    create(:job, title_no: 'Special elsewhere')
    get :search, params: ids.except(:id).merge(q: 'Special')
    expect(assigns(:jobs)).to contain_exactly(job)
  end
end
