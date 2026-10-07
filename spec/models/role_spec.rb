# frozen_string_literal: true

# == Schema Information
#
# Table name: roles
#
#  id                :bigint           not null, primary key
#  name              :string
#  title             :string
#  description       :text
#  show_in_hierarchy :boolean          default(FALSE)
#  role_id           :integer
#  group_id          :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  passable          :boolean          default(FALSE)
#
require 'rails_helper'

describe Role do
  %i[name description].each do |attribute|
    it "requires #{attribute}" do
      role = build(:role, attribute => '')
      expect(role).not_to be_valid
      expect(role.errors[attribute]).to be_present
    end
  end

  it 'accepts lowercase titles containing digits, underscores and hyphens' do
    expect(build(:role, title: 'group_2-leader')).to be_valid
  end

  ['Group', 'group leader', 'group!'].each do |title|
    it "rejects the invalid title #{title.inspect}" do
      role = build(:role, title: title)
      expect(role).not_to be_valid
      expect(role.errors[:title]).to be_present
    end
  end

  it 'keeps the title unchanged when other attributes are updated' do
    role = create(:role, title: 'original')
    role.update!(title: 'replacement', name: 'Updated name')
    expect(role.reload.title).to eq('original')
    expect(role.name).to eq('Updated name')
  end

  it 'only includes transferable roles in the passable scope' do
    passable = create(:role, :passable)
    create(:role)
    expect(Role.passable).to contain_exactly(passable)
  end

  it 'returns all descendants without including itself or unrelated roles' do
    parent = create(:role)
    child = create(:role, role: parent)
    grandchild = create(:role, role: child)
    create(:role)
    expect(parent.sub_roles).to contain_exactly(child, grandchild)
    expect(parent.child_roles).to contain_exactly(grandchild)
    expect(grandchild.sub_roles).to be_empty
  end

  it 'uses the group short name and role name for display' do
    role = build(:role, group: build(:group, abbreviation: 'MG'), name: 'Leader')
    expect(role.to_s).to eq('MG: Leader')
  end

  it 'uses the title for display when no group is assigned' do
    expect(build(:role, title: 'leader', group: nil).to_s).to eq('leader')
  end

  it 'reuses the existing superuser role' do
    role = Role.super_user
    expect { expect(Role.super_user).to eq(role) }.not_to change(Role, :count)
    expect(role.title).to eq('lim_web')
  end

  it 'removes role memberships when destroyed without deleting the members' do
    role = create(:role)
    member = create(:member)
    member.roles << role
    expect { role.destroy! }.to change(MembersRole, :count).by(-1)
    expect(Member.exists?(member.id)).to be(true)
  end
end
