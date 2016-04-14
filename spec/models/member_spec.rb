# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Member do
  context :authorization do
    it "should not be case sensitive" do
      # Although emails _are_ case sensitive, users are more likely
      # to have problems login in due to wrong case, than multiple
      # users trying to register with nearly identical email,
      # differing only by their case. That's why we've decided to
      # make login case insensitive, even though we log in by mail.
      params = { fornavn: "This Is",
                 etternavn: "Uppercase",
                 mail: "THISISUPPERCASE@Gmail.com",
                 telefon: "111 22 333",
                 passord: "password"
                }
      member = Member.create!(params)
      Member.authenticate("thisisuppercase@gmail.com", "password").should == member
    end
    it "should have a roles association" do
      member = Member.new
      member.roles.should_not be_nil
    end
    context "when an administrator" do
      it "should have administrator role" do
        member = Member.new
        admin_role = Role.new(title: "administrator")
        member.roles << admin_role

        member.roles.should include(admin_role)
      end
    end
  end
  describe :my_groups do
    before(:each) do
      @groups = [
        mock(Group),
        mock(Group),
        mock(Group),
        mock(Group),
        mock(Group),
        mock(Group)
      ]
      Group.should_receive(:all).and_return(@groups)
      @member = Member.new
      @engine = mock(Authorization::Engine)
    end

    context "with general permission to administrate admissions" do
      before(:each) do
        @engine.should_receive(:permit?).with(:show, {context: :admissions_admin_groups, user: @member}).and_return(true)
        Authorization::Engine.should_receive(:instance).once.and_return(@engine)
      end

      it "should return all groups" do
        @member.my_groups.should include(@groups[0], @groups[1], @groups[2], @groups[3], @groups[4], @groups[5])
      end
    end

    context "with permission to administrate admissions for a selected subset of groups" do
      before(:each) do
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, user: @member }).and_return(false)
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, object: @groups[0], user: @member }).and_return(true)
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, object: @groups[1], user: @member }).and_return(true)
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, object: @groups[2], user: @member }).and_return(true)
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, object: @groups[3], user: @member }).and_return(false)
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, object: @groups[4], user: @member }).and_return(false)
        @engine.should_receive(:permit?).with(:show, { context: :admissions_admin_groups, object: @groups[5], user: @member }).and_return(false)
        Authorization::Engine.should_receive(:instance).exactly(7).times.and_return(@engine)
      end

      it "should return the groups in which the user can administrate admissions for" do
        @member.my_groups.should include(@groups[0], @groups[1], @groups[2])
      end

      it "should not return groups in which the user cannot administrate admissions for" do
        @member.my_groups.should_not include(@groups[3], @groups[4], @groups[5])
      end
    end
  end
end
