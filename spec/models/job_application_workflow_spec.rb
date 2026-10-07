# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JobApplication do
  let(:application) { create(:job_application) }
  it 'creates an interview once and reuses it' do
    application
    expect { application.find_or_create_interview }.to change(Interview, :count).by(1)
    expect { application.find_or_create_interview }.not_to change(Interview, :count)
  end
  it 'requires an applicant except for pending applications' do
    pending = build(:job_application, applicant: nil)
    expect(pending).not_to be_valid
    pending.skip_applicant_validation!
    expect(pending).to be_valid
    expect(pending.validate_applicant?).to be(false)
  end
  it 'requires motivation and rejects duplicate applications to a job' do
    expect(build(:job_application, motivation: '')).not_to be_valid
    application
    expect(build(:job_application, job: application.job, applicant: application.applicant)).not_to be_valid
  end
  it 'reports withdrawn and unassigned applications' do
    expect(application.assignment_status).to eq(:no_job)
    application.update!(withdrawn: true)
    expect(application.assignment_status).to eq(:withdrawn)
  end
  %i[wanted reserved].each do |priority|
    it "reports #{priority} assignment to this or another job" do
      application.find_or_create_interview.update!(priority: priority)
      expected = priority == :reserved ? :this_job_reserved : :this_job
      expect(application.assignment_status).to eq(expected)
      other = create(:job_application, applicant: application.applicant, job: create(:job, admission: application.job.admission))
      expect(other.assignment_status).to eq(priority == :reserved ? :other_job_reserved : :other_job)
    end
  end
  it 'identifies automatic rejections and the latest admission log' do
    application.find_or_create_interview.update!(applicant_status: :rejected)
    expect(application.rejected_and_not_contacted?).to be(true)
    expect(application.last_log_entry).to be_nil
    log = LogEntry.create!(log: 'Called', admission: application.job.admission, group: application.job.group, applicant: application.applicant, member: create(:member))
    expect(application.last_log_entry).to eq(log)
  end
end
