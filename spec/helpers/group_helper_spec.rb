# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GroupHelper, type: :helper do
  it 'returns nil for an unnamed group' do
    expect(helper.abbreviate_long_name(Group.new)).to be_nil
  end
  it 'escapes a short group name' do
    expect(helper.abbreviate_long_name(Group.new(name: '<Group>'))).to eq('&lt;Group&gt;')
  end
  it 'abbreviates names at the configured length limit' do
    group = Group.new(name: 'Long name', abbreviation: 'LN')
    expect(helper.abbreviate_long_name(group, limit: 9)).to eq('<abbr title="Long name">LN</abbr>')
  end
  it 'renders a link with options' do
    group = build(:group)
    expect(helper).to receive(:render).with('groups/link', group: group, options: { class: 'group' }).and_return('link')
    expect(helper.group_link(group, class: 'group')).to eq('link')
  end
  it 'returns false when no groups exist' do
    expect(helper.can_i_manage_admissions_for_at_least_one_group?).to be(false)
  end
  it 'requires permissions for jobs, applications and interviews' do
    create(:group)
    helper.define_singleton_method(:can?) { |*_args| false }
    allow(helper).to receive(:can?).and_return(true)
    expect(helper.can_i_manage_admissions_for_at_least_one_group?).to be(true)
    allow(helper).to receive(:can?).with(:manage, kind_of(Interview)).and_return(false)
    expect(helper.can_i_manage_admissions_for_at_least_one_group?).to be(false)
  end
end
