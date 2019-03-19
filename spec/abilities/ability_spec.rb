# frozen_string_literal: true

require 'rspec'
require 'rails_helper'
require 'cancan/matchers'

describe 'ability' do
  subject(:ability) { Ability.new(member) }

  describe 'guest' do
    let(:member) { nil }

    context 'blog' do
      it { is_expected.to be_able_to([:index, :show], Blog) }
      it { is_expected.not_to be_able_to(:manage, Blog) }
    end

    context 'admissions' do
      it { is_expected.to be_able_to(:index, Admission) }
      it { is_expected.to_not be_able_to(:edit, Admission) }
      it { is_expected.to be_able_to(:show, Job) }
      it { is_expected.to be_able_to([:create, :forgot_password, :generate_forgot_password_email, :reset_password, :change_password], Applicant) }
    end

    context 'events' do
      it { is_expected.to be_able_to([:index, :show, :buy, :ical, :archive, :archive_search, :purchase_callback_success, :purchase_callback_failure, :rss], Event) }
      it { is_expected.to_not be_able_to(:edit, Event) }
    end
  end

  describe 'soker' do
    describe 'admissions' do
      let(:member) { create(:applicant, :with_job_applications) }
      context 'owned job application' do
        it { is_expected.to be_able_to([:index, :create, :update, :destroy, :down, :up], member.job_applications.first) }
      end

      let(:other_job_application) { create(:job_application) }
      context 'other job application' do
        it { is_expected.to_not be_able_to([:index, :create, :update, :destroy, :down, :up], other_job_application) }
      end

      context 'update itself' do
        it { is_expected.to be_able_to(:update, member) }
      end
    end
  end
end
