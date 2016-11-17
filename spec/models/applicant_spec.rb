# frozen_string_literal: true
require 'rails_helper'

describe Applicant, '#full_name' do
  it 'should be a combination of firstname and surname' do
    applicant = create(:applicant, firstname: 'Ola', surname: 'Norman')
    expect(applicant.full_name).to eq 'Ola Norman'
  end
end

describe Applicant, '.authenticate' do
  before do
    @email = 'joe@example.com'
    @password = 'secret'
    @applicant = create(:applicant, email: @email, password: @password, password_confirmation: @password)
  end

  it 'should return applicant given valid email and password' do
    expect(Applicant.authenticate(@email, @password)).to eq @applicant
  end

  it 'should return nil given incorrect password' do
    expect(Applicant.authenticate(@email, 'wrong_password')).to be_nil
  end

  it 'should return nil given incorrect email' do
    expect(Applicant.authenticate('incorrect-email', @password)).to be_nil
  end
end
