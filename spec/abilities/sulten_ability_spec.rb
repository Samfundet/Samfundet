# frozen_string_literal: true

require 'rspec'
require 'rails_helper'
require 'cancan/matchers'

describe 'sulten ability' do
  subject(:ability) { SultenAbility.new(member) }

  describe 'guest' do
    let(:member) { nil }

    context 'creating reservations' do
      it { is_expected.to be_able_to([:create, :success, :available], Sulten::Reservation) }
      it { is_expected.to_not be_able_to([:update, :destroy], Sulten::Reservation) }
      it { is_expected.to_not be_able_to(:update, Sulten::Table) }
    end
  end

  describe 'ksg_sulten' do
    let(:member) { create(:member, :with_role, role_title: "ksg_sulten") }

    context 'manage all sulten stuff' do
      it { is_expected.to be_able_to(:manage, Sulten::Table) }
      it { is_expected.to be_able_to(:manage, Sulten::Reservation) }
      it { is_expected.to be_able_to(:manage, Sulten::ReservationType) }
    end
  end
end
