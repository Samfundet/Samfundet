# frozen_string_literal: true

require 'rails_helper'

describe ApplicationController do
  let(:member) { create(:member) }
  let(:applicant) { create(:applicant) }

  before(:each) do
    session[:member_id] = nil
    session[:applicant_id] = nil
  end

  describe '#current_user' do
    it 'should return currently logged in member' do
      session[:member_id] = member.id
      expect(subject.current_user).to eq member
    end

    it 'should return currently logged in applicant' do
      session[:applicant_id] = applicant.id
      expect(subject.current_user).to eq applicant
    end

    it 'should return nil when not logged in' do
      expect(subject.current_user).to be_nil
    end
  end

  describe '#logged_in?' do
    it 'returns true if logged in as member' do
      session[:member_id] = member.id
      expect(subject.logged_in?).to be true
    end

    it 'returns true if logged in as applicant' do
      session[:applicant_id] = applicant.id
      expect(subject.logged_in?).to be true
    end

    it 'returns false when not logged in' do
      expect(subject.logged_in?).to be false
    end
  end
end
