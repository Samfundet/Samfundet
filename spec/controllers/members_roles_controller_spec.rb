# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MembersRolesController do
  describe :destroy do
    before(:each) do
      @role = create_role("dummyrole")
      @member = create_member("Dummy", "Member")
      @members_role = create_members_role(@member, @role)
      post :destroy, role_id: @role.id, id: @members_role.id
    end

    it "should redirect to role page" do
      response.should redirect_to(role_path(@role))
    end

    it "should set success flash" do
      flash[:success].should_not be_nil
    end
  end

  describe :create do
    context "when member doesn't already have the role" do
      before(:each) do
        @member = mock_model(Member)
        @members_role = mock_model(MembersRole)
        member_collection = mock("member_collection")
        member_collection.should_receive(:include?).with(@member).and_return(false)
        @role = mock_model(Role)
        @role.should_receive(:members).and_return(member_collection)
        @members_role.should_receive(:role).at_least(:twice).and_return(@role)
        @members_role.should_receive(:member).and_return(@member)
        @members_role.should_receive(:save!)
        MembersRole.should_receive(:new).and_return(@members_role)
        Member.should_receive(:find).and_return(@member)
        Role.should_receive(:find).and_return(@role)
        post :create, role_id: @role.id, id: @members_role.id
      end

      it "should redirect to role page" do
        response.should redirect_to(role_path(@role))
      end

      it "should set success flash" do
        flash[:success].should_not be_nil
      end
    end

    context "when member already have the role" do
      before(:each) do
        @member = mock_model(Member)
        @members_role = mock_model(MembersRole)
        member_collection = mock("member_collection")
        member_collection.should_receive(:include?).with(@member).and_return(true)
        @role = mock_model(Role)
        @role.should_receive(:members).and_return(member_collection)
        @members_role.should_receive(:role).at_least(:twice).and_return(@role)
        @members_role.should_receive(:member).and_return(@member)
        MembersRole.should_receive(:new).and_return(@members_role)
        Member.should_receive(:find).and_return(@member)
        Role.should_receive(:find).and_return(@role)
        post :create, role_id: @role.id, member_id: @member.id
      end

      it "should redirect to role page" do
        response.should redirect_to(role_path(@role))
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end
    end
  end
end
