# frozen_string_literal: true

# == Schema Information
#
# Table name: campus
#
#  id         :bigint           not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  active     :boolean          default(TRUE)
#
require 'rspec'
require 'rails_helper'
require 'pp'

describe Campus do
  it 'should show name when calling the to_s function' do
    campus = create(:campus)
    expect(campus.to_s).to eq(campus.name)
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

    number_of_applicants = Campus.number_of_applicants_given_admission(admission)[applicant.campus.id]

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

RSpec.describe Campus do
  it 'counts applicants once even when they apply for multiple jobs' do
    admission = create(:admission)
    applicant = create(:applicant)
    2.times { create(:job_application, applicant: applicant, job: create(:job, admission: admission)) }
    counts = Campus.number_of_applicants_given_admission(admission)
    expect(counts[applicant.campus_id]).to eq(1)
    expect(counts[-1]).to eq(0)
  end
  it 'reports no current applicants when there is no current admission' do
    expect(Campus.number_of_applicants_current_admission).to eq(0)
  end
end
