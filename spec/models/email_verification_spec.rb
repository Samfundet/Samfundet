# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EmailVerification do
  it 'stores the token for its applicant with an initial send count' do
    applicant = create(:applicant)
    verification = EmailVerification.create!(applicant: applicant, verification_hash: 'token')
    expect(verification.reload.count).to eq(1)
    expect(applicant.reload.email_verification).to eq(verification)
    expect(verification.applicant).to eq(applicant)
  end
end
