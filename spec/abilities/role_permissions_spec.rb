# frozen_string_literal: true

require 'rails_helper'
RSpec.describe Ability do
  {
    'mg_layout' => [Event, Image, FrontPageLock],
    'mg_redaksjon' => [Blog, Event, Page, FrontPageLock, EverythingClosedPeriod, Area, Image, InfoBox],
    'styret' => [Blog, Document, CrowdFundingSupporter, Image, InfoBox],
    'raadet' => [Document], 'fs' => [Document], 'fs_fu' => [CrowdFundingSupporter],
    'gu_nestleder' => [Admission, JobApplication]
  }.each do |title, resources|
    it "grants #{title} management of its resources without superuser access" do
      member = create(:member, :with_role, role_title: title)
      ability = Ability.new(member)
      resources.each { |resource| expect(ability.can?(:manage, resource)).to be(true) }
      expect(ability.can?(:steal_identity, Member)).to be(false)
    end
  end
  it 'limits page owners to pages belonging to their role hierarchy' do
    member = create(:member)
    parent = create(:role)
    child = create(:role, role: parent)
    member.roles << parent
    owned = create(:page, role: child)
    other = create(:page)
    ability = Ability.new(member)
    expect(ability.can?(:update, owned)).to be(true)
    expect(ability.can?(:update, other)).to be(false)
  end
  it 'allows role transfer only for roles the user owns and that are passable' do
    member = create(:member)
    passable = create(:role, :passable)
    other = create(:role, :passable)
    member.roles << passable
    ability = Ability.new(member)
    expect(ability.can?(:pass, passable)).to be(true)
    expect(ability.can?(:pass, other)).to be(false)
  end
end

RSpec.describe AdmissionsAdminAbility do
  it 'grants no administration rights to guests or applicants' do
    [nil, build(:applicant)].each do |user|
      expect(AdmissionsAdminAbility.new(user).can?(:manage, Admission)).to be(false)
    end
  end
  it 'grants admission leaders rights without unrelated member administration' do
    member = create(:member, :with_role, role_title: 'gu_nestleder')
    ability = AdmissionsAdminAbility.new(member)
    [Admission, Applicant, Group, Interview, Job, JobApplication, LogEntry].each { |resource| expect(ability.can?(:manage, resource)).to be(true) }
    expect(ability.can?(:manage, Member)).to be(false)
  end
  it 'grants superusers all administration rights' do
    member = create(:member)
    member.roles << Role.super_user
    expect(AdmissionsAdminAbility.new(member).can?(:manage, Admission)).to be(true)
  end
end
