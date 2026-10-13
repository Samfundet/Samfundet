# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Job do
  let(:job) { create(:job) }
  it 'splits processed, accepted, rejected, withdrawn and unprocessed applications' do
    accepted = create(:job_application, job: job)
    accepted.find_or_create_interview.update!(applicant_status: :accepted)
    rejected = create(:job_application, job: job)
    rejected.find_or_create_interview.update!(applicant_status: :rejected)
    unscheduled = create(:job_application, job: job)
    unprocessed = create(:job_application, job: job)
    unprocessed.find_or_create_interview
    withdrawn = create(:job_application, job: job, withdrawn: true)
    expect(job.processed_applications).to match_array([accepted, rejected])
    expect(job.accepted_applications).to contain_exactly(accepted)
    expect(job.automatically_rejected_applications).to contain_exactly(rejected)
    expect(job.contacted_applications).to contain_exactly(accepted)
    expect(job.withdrawn_applications).to contain_exactly(withdrawn)
    expect(job.unprocessed_applications).to match_array([unscheduled, unprocessed])
    accepted.interview.update!(time: 1.day.from_now)
    expect(job.job_applications_with_interviews).to eq([accepted])
    expect(job.job_applications_without_interviews).not_to include(accepted)
  end
  it 'normalizes tags and formats localized slugs' do
    job.tag_titles = 'Music, CONCERT'
    expect(job.tag_titles).to eq('music, concert')
    expect(job.to_param).to include(job.id.to_s)
    other = build(:job, title_en: 'Zebra')
    expect(job <=> other).to eq(job.title <=> other.title)
    job.title_en = job.title_no = nil
    expect(job.to_param).to eq(job.id.to_s)
  end
end
