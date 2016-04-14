# -*- encoding : utf-8 -*-
require 'spec_helper'

describe UserSessionsController do
  describe :destroy do
    it "should clear the member id" do
      session[:member_id] = 1337
      post :destroy
      session[:member_id].should be_nil
    end

    it "should clear the applicant id" do
      session[:applicant_id] = 1137
      post :destroy
      session[:applicant_id].should be_nil
    end

    it "should redirect to the root" do
      post :destroy
      response.should redirect_to(root_path)
    end

    it "should set flash message" do
      post :destroy
      flash[:success].should_not be_nil
    end
  end
end
