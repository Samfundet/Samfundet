# frozen_string_literal: true

# == Schema Information
#
# Table name: members
#
#  medlem_id :bigint           not null, primary key
#  fornavn   :string
#  etternavn :string
#  mail      :string
#  telefon   :string
#  passord   :string
#
require 'rails_helper'

describe Member do
  %i[fornavn etternavn mail telefon].each do |attribute|
    it "requires #{attribute}" do
      member = build(:member, attribute => nil)
      expect(member).not_to be_valid
      expect(member.errors[attribute]).to be_present
    end
  end

  it 'combines first and last names' do
    member = build(:member, fornavn: 'Ola', etternavn: 'Nordmann')
    expect(member.firstname).to eq('Ola')
    expect(member.lastname).to eq('Nordmann')
    expect(member.full_name).to eq('Ola Nordmann')
  end

  describe '.authenticate' do
    let!(:member) { create(:member, mail: 'ola@example.com', passord: 'secret') }

    it 'accepts the member ID and correct password' do
      expect(Member.authenticate(member.id.to_s, 'secret')).to eq(member)
    end

    it 'matches email addresses without regard to case' do
      expect(Member.authenticate('OLA@EXAMPLE.COM', 'secret')).to eq(member)
    end

    it 'rejects an incorrect password' do
      expect(Member.authenticate(member.mail, 'wrong')).to be_nil
    end

    it 'rejects an unknown email address' do
      expect(Member.authenticate('unknown@example.com', 'secret')).to be_nil
    end
  end

  describe '#sub_roles' do
    it 'includes assigned roles and their descendants but excludes unrelated roles' do
      member = create(:member)
      parent = create(:role)
      child = create(:role, role: parent)
      grandchild = create(:role, role: child)
      create(:role)
      member.roles << parent

      expect(member.child_roles).to contain_exactly(child, grandchild)
      expect(member.sub_roles).to contain_exactly(parent, child, grandchild)
    end
  end

  describe '#active_membership?' do
    it 'returns false without a membership card' do
      expect(build(:member).active_membership?).to be(false)
    end

    [true, false].each do |active|
      it "returns #{active} when the membership card reports that status" do
        member = build(:member)
        allow(member).to receive(:membership_card).and_return(double('membership card', active?: active))
        expect(member.active_membership?).to be(active)
      end
    end
  end
end
