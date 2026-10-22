# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ApplicantsHelper, type: :helper do
  it 'requires both email and recovery hash' do
    [{}, { email: 'a@example.com' }, { recovery_hash: 'token' }].each do |args|
      expect { helper.password_reset_link(args) }.to raise_error(RuntimeError, 'Email or recovery_hash not supplied.')
    end
  end
  it 'generates a password recovery link' do
    expect(helper).to receive(:reset_password_url).with(email: 'a@example.com', hash: 'token').and_return('https://test.host/reset')
    expect(helper.password_reset_link(email: 'a@example.com', recovery_hash: 'token')).to eq('https://test.host/reset')
  end
end
