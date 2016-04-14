# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MembersController do
  describe :search do
    it "should assign @members with the search result" do
      query = "this is a search query"
      members = [
        mock_model(Member).as_null_object,
        mock_model(Member).as_null_object,
        mock_model(Member).as_null_object
      ]
      Member.should_receive(:where).and_return(members)
      post :search, term: query, format: :json
      assigns(:members).should == members
    end
  end

  describe :control_panel do
    it "should assign @passable_roles with roles that are passable" do
      @roles = [mock_model(Role)]
      @roles_collection = mock("roles_collection")
      @roles_collection.should_receive(:where).and_return(@roles)

      @member = mock_model(Member)
      @member.should_receive(:roles).and_return(@roles_collection)
      session[:member_id] = @member.id
      Member.should_receive(:find).with(@member.id).and_return(@member)

      get :control_panel
      assigns[:passable_roles].should == @roles
    end
  end

  describe :steal_identity do
    it "should set the session value member_id to the id of the member having the email specified and redirect to home page" do
      member = mock_model(Member).as_null_object
      # There's a lot of stuff going on in ActiveRecord::Base#find,
      # but to keep things simple we'll just take a string as the ID here.
      Member.stub(:find).with("2").and_return(member)
      post :steal_identity, member_id: "2 - Fornavn Etternavn".to_i # see members#search
      session[:member_id].should == member.id
      response.should redirect_to(root_path)
    end
  end
end
