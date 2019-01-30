# frozen_string_literal: true

require 'rails_helper'

describe JobApplication do
  it 'delegates title to job' do
    job = create(:job, title_no: 'Tittel', title_en: 'Title')
    job_application = create(:job_application, job: job)

    expect(job_application.title).to eq job.title
  end

  it 'removes corresponding interview when destroying itself' do
    job_application = create(:job_application)
    interview = job_application.find_or_create_interview
    job_application.destroy

    expect(described_class.find_by(id: interview.id)).to be_nil
  end
end
