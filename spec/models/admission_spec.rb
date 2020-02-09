# frozen_string_literal: true

require 'rails_helper'

describe Admission, '.open_admissions?' do
  it 'returns true if open admissions' do
    create(:admission)
    expect(Admission.open_admissions?).to eq true
  end

  it 'returns false if no open admissions' do
    create(:admission, shown_from: 2.days.from_now)
    create(:admission, :past)
    expect(Admission.open_admissions?).to eq false
  end
end

describe Admission, '.active_admissions?' do
  # Defined as at admin priority deadline not passed
  it 'returns true if active admissions' do
    create(:admission)
    expect(Admission.active_admissions?).to eq true
  end

  it 'returns false if no active admissions' do
    create(:admission, :past)
    expect(Admission.active_admissions?).to eq false
  end
end

describe Admission, '#appliable?' do
  # (actual_application_deadline > Time.current) && (shown_from < Time.current)
  it 'returns true if actual deadline in the future and shown from in the past' do
    admission = create(:admission)
    expect(admission.appliable?).to eq true
  end

  it 'should be true just after the shown application deadline' do
    admission = create(:admission,
                       shown_application_deadline: 1.minute.ago,
                       actual_application_deadline: 1.hour.from_now)
    expect(admission.appliable?).to eq true
  end

  it 'should be false some time after the shown application deadline' do
    admission = create(:admission,
                       shown_application_deadline: 1.hour.ago,
                       actual_application_deadline: 1.minute.ago)
    expect(admission.appliable?).to eq false
  end
end

describe Admission, '.unlogged_applicants' do
  let(:user) { create(:member, passord: 'password') }

  let(:admission1) { create(:admission_with_jobs) }
  let(:admission2) { create(:admission_with_jobs) }

  let(:applicant1) { create(:applicant, :with_job_applications) }
  let(:applicant2) { create(:applicant, :with_job_applications) }
  let(:applicant3) { create(:applicant, :with_job_applications) }
  let(:applicant4) { create(:applicant, :with_job_applications) }

  before do
    admission1.jobs.first.job_applications << applicant1.job_applications
    admission1.jobs.first.job_applications << applicant2.job_applications

    admission2.jobs.first.job_applications << applicant3.job_applications
    admission2.jobs.first.job_applications << applicant4.job_applications
  end

  it 'should correctly count unlogged applicants' do
    expect(admission1.unlogged_applicants.count).to eq(2)
  end

  it 'should correctly count unlogged applicants after some have been logged' do
    group = applicant1.job_applications.first.job.group
    applicant1.log_with_text('logged', group, admission1, user)

    expect(admission1.unlogged_applicants.count).to eq(1)
  end

  it 'should correctly count unlogged applicants when all have been logged' do
    admission1.log_all_unlogged_applicants('logged', user)

    expect(admission1.unlogged_applicants.count).to eq(0)
  end

  it 'should not log applicants from other admissions when logging everyone in an admission' do
    admission1.log_all_unlogged_applicants('logged', user)

    expect(admission1.unlogged_applicants.count).to eq(0)
    expect(admission2.unlogged_applicants.count).to eq(2)
  end

  it 'should not log applicants from other admissions when logging some applicants in a group' do
    group = applicant1.job_applications.first.job.group

    admission1.log_applicants_in_group([applicant1], group, 'logged', user)

    expect(admission1.unlogged_applicants.count).to eq(1)
    expect(admission2.unlogged_applicants.count).to eq(2)
  end
end
