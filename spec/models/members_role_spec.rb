# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersRole do
  it 'requires both member and role IDs' do
    record = MembersRole.new
    expect(record).not_to be_valid
    expect(record.errors[:member_id]).to be_present
    expect(record.errors[:role_id]).to be_present
  end
  it 'connects the assigned role to its member' do
    member = create(:member)
    role = create(:role)
    membership = MembersRole.create!(member: member, role: role)
    expect(membership.member).to eq(member)
    expect(member.reload.roles).to include(role)
  end
end
