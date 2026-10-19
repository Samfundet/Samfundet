# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MembersRolesController, type: :controller do
  let(:member) { create(:member) }
  let(:role) { create(:role) }
  before do
    admin = create(:member)
    admin.roles << Role.super_user
    login_member(admin)
  end
  it 'assigns a role to the selected member' do
    expect { post :create, params: { member_id: member.id, role_id: role.id } }.to change(MembersRole, :count).by(1)
    expect(member.roles).to include(role)
  end
  it 'does not duplicate an existing membership' do
    MembersRole.create!(member: member, role: role)
    expect { post :create, params: { member_id: member.id, role_id: role.id } }.not_to change(MembersRole, :count)
    expect(flash[:error]).to eq('Medlemmet har allerede denne rollen.')
  end
  it 'removes a membership without deleting the member or role' do
    membership = MembersRole.create!(member: member, role: role)
    expect { delete :destroy, params: { id: membership.id, role_id: role.id } }.to change(MembersRole, :count).by(-1)
    expect(member.reload.roles).not_to include(role)
    expect(Role.exists?(role.id)).to be(true)
  end
end
