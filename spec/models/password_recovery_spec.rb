# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PasswordRecovery do
  it 'keeps recovery tokens isolated by applicant' do
    applicant = create(:applicant)
    other = create(:applicant)
    recovery = PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'token')
    expect(applicant.password_recoveries).to contain_exactly(recovery)
    expect(other.password_recoveries).to be_empty
  end
end
