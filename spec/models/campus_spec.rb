# frozen_string_literal: true

require 'rspec'
require 'rails_helper'
require 'pp'

describe Campus do
  it 'should show name when calling the to_s function' do
    campus = create(:campus)
    expect(campus.to_s).to be(campus.name)
  end

  it 'should not have any applicants if just created' do
    campus = create(:campus)
    expect(campus.number_of_applicants).to be(0)
  end

  it 'should not have any applicants if there are no admissions' do
    expect(Campus.number_of_applicants_given_admission(nil)).to be(0)
  end

  it 'should have an applicant if someone has applied from a particular campus' do
    applicant = create(:applicant)
    job = create(:job)
    admission = create(:admission)
    admission.jobs << job
    _ = create(:job_application, job: job, applicant: applicant)

    # number_of_applicants_given_admission returns a dictionary.
    # Calling first returns an array [key, value], so accessing the second value
    # returns the actual number we're looking for.
    # TODO: Improve this test.
    number_of_applicants = Campus.number_of_applicants_given_admission(admission).first.second

    expect(number_of_applicants).to eq(1)
  end

  it 'should have an applicant if someone has applied from a particular campus current' do
    applicant = create(:applicant, :with_job_applications)
    admission = create(:admission_with_jobs)
    campus = create(:campus)

    campus.applicants << applicant
    admission.jobs.first.job_applications << applicant.job_applications

    number_of_applicants = Campus.number_of_applicants_current_admission[campus.id]

    expect(number_of_applicants).to eq(1)
  end
end
