# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VerifyEmailApplicantMailer do
  let(:applicant) { create(:applicant) }
  it 'addresses a verification message to the applicant and includes the token URL' do
    mail = described_class.send_applicant_email_verification(applicant)
    expect(mail.to).to eq([applicant.email])
    expect(mail.from).to eq(['mg-web@samfundet.no'])
    expect(mail.subject).to eq(I18n.t('applicants.email_verification.email_subject'))
    expect(mail.body.decoded).to include(applicant.email_verification.verification_hash, 'test.host')
  end
  it 'replaces an existing verification token and increments the send count' do
    old = EmailVerification.create!(applicant: applicant, verification_hash: 'old-token', count: 2)
    described_class.send_applicant_email_verification(applicant).message
    expect(EmailVerification.count).to eq(1)
    expect(old.reload.count).to eq(3)
    expect(old.verification_hash).not_to eq('old-token')
  end
  it 'uses the ISFIT subject for ISFIT admissions' do
    admission = create(:admission, title: 'ISFIT admission')
    mail = described_class.send_applicant_email_verification(applicant, admission)
    expect(mail.subject).to eq(I18n.t('applicants.email_verification.email_subject_isfit'))
  end
end
