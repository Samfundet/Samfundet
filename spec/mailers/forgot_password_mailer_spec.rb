# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ForgotPasswordMailer do
  it 'includes the recovery URL and addresses the correct applicant' do
    applicant = create(:applicant)
    PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'recovery-token')
    mail = described_class.forgot_password_email(applicant)
    expect(mail.to).to eq([applicant.email])
    expect(mail.from).to eq(['mg-web@samfundet.no'])
    expect(mail.subject).to eq(I18n.t('applicants.password_recovery.email_subject'))
    expect(mail.body.decoded).to include('recovery-token', applicant.full_name, 'test.host')
  end
end
