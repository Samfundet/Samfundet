# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationController do

  context :authorization do
    before(:each) do
      @member = mock_model(Member)
      Member.stub(:find).with(@member.id).and_return(@member)

      @applicant = mock_model(Applicant)
      Applicant.stub(:find).with(@applicant.id).and_return(@applicant)
    end

    describe :current_user do
      it "should return currently logged in member" do
        session[:member_id] = @member.id
        controller.current_user.should == @member
      end

      it "should return currently logged in applicant" do
        session[:applicant_id] = @applicant.id
        controller.current_user.should == @applicant
      end

      it "should return nil when not logged in" do
        controller.current_user.should be_nil
      end
    end

    describe :logged_in? do
      it "should return true if logged in as member" do
        session[:member_id] = @member.id
        controller.logged_in?.should be_true
      end

      it "should return true if logged in as applicant" do
        session[:applicant_id] = @applicant.id
        controller.logged_in?.should be_true
      end

      it "should return false when not logged in" do
        controller.logged_in?.should be_false
      end
    end
  end
end
