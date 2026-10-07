# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib/generate_roles')
RSpec.describe 'role generation' do
  it 'creates a group role hierarchy and special organization roles' do
    group = create(:group, abbreviation: 'testgroup')
    generate_roles
    leader = Role.find_by!(title: 'testgroup_gjengsjef')
    expect(leader.group).to eq(group)
    expect(Role.find_by!(title: 'testgroup_opptaksansvarlig').role).to eq(leader)
    expect(Role.find_by!(title: 'testgroup_arrangementansvarlig').role).to eq(leader)
    expect(Role.find_by!(title: 'testgroup').role).to eq(leader)
    %w[mg_layout mg_layout_sjef mg_redaksjon ksg_sulten gu_nestleder].each { |title| expect(Role.exists?(title: title)).to be(true) }
  end
end
