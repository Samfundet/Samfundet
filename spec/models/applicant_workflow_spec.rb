# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Applicant do
  let(:applicant) { create(:applicant) }
  let(:admission) { create(:admission) }
  let(:group) { create(:group) }
  let(:job) { create(:job, admission: admission, group: group) }
  let(:application) { create(:job_application, applicant: applicant, job: job) }
  it 'requires matching confirmation only when registering' do
    invalid = build(:applicant, email_confirmation: 'wrong@example.com')
    expect(invalid).not_to be_valid
    expect(invalid.errors[:email_confirmation]).to be_present
    applicant.reload.email_confirmation = nil
    expect(applicant).to be_valid
  end
  it 'authenticates by phone and case-insensitive email while excluding disabled applicants' do
    expect(Applicant.authenticate(applicant.phone, 'password')).to eq(applicant)
    expect(Applicant.authenticate(applicant.email.upcase, 'password')).to eq(applicant)
    applicant.update!(disabled: true)
    expect(Applicant.authenticate(applicant.email, 'password')).to be_nil
    expect(Applicant.authenticate('invalid', 'password')).to be_nil
  end
  it 'changes the password hash without storing the plain password' do
    original = applicant.hashed_password
    applicant.update!(password: 'new-password', password_confirmation: 'new-password')
    expect(applicant.reload.hashed_password).not_to eq(original)
    expect(Applicant.authenticate(applicant.email, 'new-password')).to eq(applicant)
    expect(Applicant.authenticate(applicant.email, 'password')).to be_nil
  end
  it 'rejects passwords that are too short or incorrectly confirmed' do
    expect(build(:applicant, password: 'short', password_confirmation: 'short')).not_to be_valid
    expect(build(:applicant, password_confirmation: 'different')).not_to be_valid
  end
  it 'limits password recovery to five requests per day' do
    expect(applicant.can_recover_password?).to be(true)
    5.times { PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'token') }
    expect(applicant.can_recover_password?).to be(false)
    PasswordRecovery.update_all(created_at: 2.days.ago)
    expect(applicant.can_recover_password?).to be(true)
  end
  it 'accepts recovery hashes only within one hour' do
    hash = applicant.create_recovery_hash
    expect(hash).to match(/\A[0-9a-f]{64}\z/)
    recovery = PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: hash)
    expect(applicant.check_hash(hash)).to be(true)
    expect(applicant.check_hash('invalid')).to be(false)
    recovery.update!(created_at: 2.hours.ago)
    expect(applicant.reload.check_hash(hash)).to be(false)
  end
  it 'consumes valid verification hashes and rejects expired hashes' do
    hash = applicant.create_email_verification_hash
    verification = EmailVerification.create!(applicant: applicant, verification_hash: hash)
    expect(applicant.check_email_verification_hash('invalid')).to be(false)
    verification.update!(updated_at: 2.hours.ago)
    expect(applicant.reload.check_email_verification_hash(hash)).to be(false)
    verification.update!(updated_at: Time.current)
    expect { expect(applicant.reload.check_email_verification_hash(hash)).to be(true) }.to change(EmailVerification, :count).by(-1)
    expect(applicant.reload.check_email_verification_hash(hash)).to be(false)
  end
  it 'counts scheduled interviews and applications within an admission' do
    application.find_or_create_interview.update!(time: 1.day.from_now)
    expect(applicant.get_set_interviews(admission)).to eq([application.interview])
    expect(applicant.set_interviews_string(admission)).to eq('1 av 1')
    expect(applicant.jobs_applied_to(admission)).to eq([job])
    expect(applicant.open_job_applications(admission)).to eq([application])
    expect(applicant.open_job_applications_in_group(admission, group)).to eq([application])
  end
  it 'excludes withdrawn applications from priority and group lists' do
    first = application
    second = create(:job_application, applicant: applicant, job: create(:job, admission: admission, group: group))
    expect(applicant.priority_of_job_application(admission, second)).to eq(2)
    expect(applicant.priority_of_job_application_string(admission, second)).to eq('2 av 2')
    expect(applicant.lowest_priority_group(admission)).to eq(group.id)
    first.update!(withdrawn: true)
    applicant.reload
    expect(applicant.open_job_applications(admission)).to eq([second])
    expect(applicant.priority_of_job_application(admission, second)).to eq(1)
  end
  it 'selects the highest-priority unscheduled application in a group' do
    application.find_or_create_interview
    expect(applicant.top_priority_job_application_at_group_without_interview(admission, group)).to eq(application)
    application.interview.update!(time: 1.day.from_now)
    applicant.reload
    expect(applicant.top_priority_job_application_at_group_without_interview(admission, group)).to be_nil
  end
  it 'distinguishes wanted, reserved and unassigned applications' do
    interview = application.find_or_create_interview
    expect(applicant.assigned_job_application(admission)).to be_nil
    expect(applicant.flagged?(admission)).to be(false)
    interview.update!(priority: :reserved)
    expect(applicant.assigned_job_application(admission)).to eq(application)
    expect(applicant.reserved?(admission)).to be(true)
    expect(applicant.unwanted?(admission)).to be(false)
    interview.update!(priority: :not_wanted)
    expect(applicant.unwanted?(admission)).to be(true)
  end
  it 'lists interested applicants only if they have applications and are not wanted' do
    applicant.update!(interested_other_positions: true)
    application.find_or_create_interview.update!(priority: :not_wanted)
    expect(Applicant.interested_other_positions(admission)).to eq([applicant])
    application.interview.update!(priority: :wanted)
    expect(Applicant.interested_other_positions(admission)).to eq([])
  end
end
