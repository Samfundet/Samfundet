# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CrowdFundingSupporter do
  let(:attributes) { { name: 'Supporter', name_short: 'S', amount: 100, donors: 1, supporter_type: :group } }
  it 'accepts zero donations but requires at least one donor' do
    expect(CrowdFundingSupporter.new(attributes.merge(amount: 0))).to be_valid
    expect(CrowdFundingSupporter.new(attributes.merge(amount: -1))).not_to be_valid
    expect(CrowdFundingSupporter.new(attributes.merge(donors: 0))).not_to be_valid
  end
  it 'requires all identifying attributes' do
    attributes.keys.each do |key|
      expect(CrowdFundingSupporter.new(attributes.merge(key => nil))).not_to be_valid
    end
  end
  it 'identifies student unions and groups independently' do
    supporter = CrowdFundingSupporter.new(attributes)
    expect(supporter).to be_group_supporter_type
    supporter.supporter_type = :student_union
    expect(supporter).to be_student_union_supporter_type
  end
end
