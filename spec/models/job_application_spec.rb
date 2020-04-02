# frozen_string_literal: true

# == Schema Information
#
# Table name: job_applications
#
#  id           :bigint           not null, primary key
#  motivation   :text
#  priority     :integer
#  applicant_id :integer
#  job_id       :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  withdrawn    :boolean          default(FALSE)
#
require 'rails_helper'

describe JobApplication do
  it 'should delegate title to job' do
    job = create(:job, title_no: 'Tittel', title_en: 'Title')
    job_application = create(:job_application, job: job)

    expect(job_application.title).to eq job.title
  end

  it 'should remove corresponding interview when destroying itself' do
    job_application = create(:job_application)
    interview = job_application.find_or_create_interview
    job_application.destroy

    expect(JobApplication.find_by(id: interview.id)).to be_nil
  end
end
