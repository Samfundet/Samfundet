# frozen_string_literal: true

require 'rails_helper'

describe Group, 'short_name' do
  it 'returns the abbreviation if present' do
    group = create(:group, name: 'MG:WEB', abbreviation: 'LIM')
    expect(group.short_name).to eq 'LIM'
  end

  it 'returns name if abbreviation not present' do
    group = create(:group, name: 'MG:WEB', abbreviation: '')
    expect(group.short_name).to eq 'MG:WEB'
  end
end

describe Group, '#interviews' do
  xit 'should maybe be rewritten'
end
