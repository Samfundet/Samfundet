# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ApplicantVerificationHelper, type: :helper do
  it 'requires email, applicant ID and verification hash' do
    required = { email: 'a@example.com', applicant_id: 1, verification_hash: 'token' }
    required.keys.each do |key|
      expect { helper.email_verification_link(required.except(key)) }.to raise_error(RuntimeError)
    end
  end
  it 'includes the optional admission in the verification link' do
    expect(helper).to receive(:verify_email_url).with(email: 'a@example.com', applicant: 1, hash: 'token', admission: 2).and_return('link')
    expect(helper.email_verification_link(email: 'a@example.com', applicant_id: 1, verification_hash: 'token', admission_id: 2)).to eq('link')
  end
end
