require 'rails_helper'

describe JobApplication do
  it 'should delegate title to job' do
    job = create(:job, title_no: "Tittel", title_en: "Title")
    job_application = create(:job_application, job: job)

    expect(job_application.title).to eq job.title
  end
end
