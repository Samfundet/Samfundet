# frozen_string_literal: true

require 'rspec'
require 'rails_helper'
require 'cancan/matchers'

describe Member do
  describe 'abilities' do
    subject(:ability) { Ability.new(member) }

    context 'when not logged in' do
      let(:member) { nil }

      # Testin guest n blogs
      it { is_expected.to be_able_to(:read, Blog) }
      it { is_expected.not_to be_able_to(:manage, Blog) }

      # Testing guest n admissions
      it { is_expected.to be_able_to(:read, Admission) }
      it { is_expected.to be_able_to(:read, Job) }
      it { is_expected.to be_able_to(:create, JobApplication) }
      it { is_expected.to be_able_to(%i(create forgot_password generate_forgot_password_email reset_password change_password), Applicant) }
    end

    context 'when logged in as a regular user' do
      let(:member) { create(:member) }

      it { is_expected.to be_able_to(:read, Blog) }
    end

    context 'when mg_layout is logged in' do
      let(:role) { create(:role, name: 'mg_layout') }
      let(:member) { create(:member, roles: [role]) }

      it { is_expected.to be_able_to(:manage, Event) }
    end
  end
end
