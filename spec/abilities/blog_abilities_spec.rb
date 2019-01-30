# frozen_string_literal: true

require 'rspec'
require 'rails_helper'
require 'cancan/matchers'

describe Blog do
  describe Ability do
    # before do
    #   @member = create(:member)
    #   @image = create(:image)
    # end

    context 'when user is logged in as guest' do
      it { is_expected.to be_able_to(:read, described_class.new) }
      it { is_expected.not_to be_able_to(:edit, described_class.new) }
    end
  end
end
