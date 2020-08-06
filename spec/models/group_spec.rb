# frozen_string_literal: true

# == Schema Information
#
# Table name: groups
#
#  id                :bigint           not null, primary key
#  name              :string
#  abbreviation      :string
#  website           :string
#  group_type_id     :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  short_description :text
#  long_description  :text
#  page_id           :integer
#
require 'rails_helper'

describe Group, 'short_name' do
  it 'should return the abbreviation if present' do
    group = create(:group, name: 'MG:WEB', abbreviation: 'LIM')
    expect(group.short_name).to eq 'LIM'
  end

  it 'should return name if abbreviation not present' do
    group = create(:group, name: 'MG:WEB', abbreviation: '')
    expect(group.short_name).to eq 'MG:WEB'
  end
end

describe Group, '#interviews' do
  xit 'should maybe be rewritten'
end
