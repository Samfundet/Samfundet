# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Group do
  it 'compares names and formats abbreviations and slugs' do
    first = build(:group, id: 2, name: 'Alpha', abbreviation: 'AL')
    other = build(:group, name: 'Zebra')
    expect(first <=> other).to eq(-1)
    expect(first.to_s).to eq('Alpha (AL)')
    expect(first.to_param).to eq('2-al')
    first.abbreviation = ''
    expect(first.to_s).to eq('Alpha')
    first.name = nil
    expect(first.to_param).to eq('2')
  end
  it 'generates role symbols from its short name' do
    group = build(:group, abbreviation: 'MG Web!')
    expect(group.member_role).to eq(:mg_web)
    expect(group.admission_responsible_role).to eq(:mg_web_opptaksansvarlig)
    expect(group.group_leader_role).to eq(:mg_web_gjengsjef)
    expect(group.event_manager_role).to eq(:mg_web_arrangementansvarlig)
  end
end
