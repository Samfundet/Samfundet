# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionsAdmin::LogEntriesController, type: :controller do
  let(:admin) { create(:member) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  let(:admission) { create(:admission) }
  let(:group) { create(:group) }
  let(:applicant) { create(:applicant) }
  let(:ids) { { admission_id: admission.id, group_id: group.id, applicant_id: applicant.id } }
  it 'records a log entry with the current member and selected participants' do
    expect { post :create, params: ids.merge(log_entry: { log: 'Called' }) }.to change(LogEntry, :count).by(1)
    log = LogEntry.last
    expect(log.member).to eq(admin)
    expect(log.applicant).to eq(applicant)
    expect(log.admission).to eq(admission)
    expect(log.group).to eq(group)
  end
  it 'rejects an empty log without persisting it' do
    expect { post :create, params: ids.merge(log_entry: { log: '' }) }.not_to change(LogEntry, :count)
    expect(flash[:error]).to be_present
  end
  it 'deletes the selected log entry' do
    log = LogEntry.create!(admission: admission, group: group, applicant: applicant, member: admin, log: 'Called')
    expect { delete :destroy, params: ids.merge(id: log.id) }.to change(LogEntry, :count).by(-1)
  end
end
