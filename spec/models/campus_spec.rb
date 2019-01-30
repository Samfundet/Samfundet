# frozen_string_literal: true

require 'rspec'
require 'rails_helper'
require 'pp'

describe Campus do
  it 'shows name when calling the to_s function' do
    campus = create(:campus)
    expect(campus.to_s).to be(campus.name)
  end

  it 'does not have any applicants if just created' do
    campus = create(:campus)
    expect(campus.number_of_applicants).to be(0)
  end

  it 'does not have any applicants if there are no admissions' do
    expect(described_class.number_of_applicants_given_admission(nil)).to be(0)
  end

  it 'has an applicant if someone has applied from a particular campus' do
    applicant = create(:applicant)
    job = create(:job)
    admission = create(:admission)
    admission.jobs << job
    _ = create(:job_application, job: job, applicant: applicant)

    # number_of_applicants_given_admission returns a dictionary.
    # Calling first returns an array [key, value], so accessing the second value
    # returns the actual number we're looking for.
    # TODO: Improve this test.
    number_of_applicants = described_class.number_of_applicants_given_admission(admission).first.second

    expect(number_of_applicants).to eq(1)
  end

  it 'has an applicant if someone has applied from a particular campus current' do
    DatabaseCleaner.clean

    applicant = create(:applicant)
    job = create(:job)
    admission = create(:admission)
    _ = create(:job_application, job: job, applicant: applicant)

    admission.user_priority_deadline = 1.week.ago

    # number_of_applicants_given_admission returns a dictionary.
    # Calling first returns an array [key, value], so accessing the second value
    # returns the actual number we're looking for.
    # TODO: Improve this test.
    number_of_applicants = described_class.number_of_applicants_current_admission.first.second

    expect(number_of_applicants).to eq(1)
  end
end
