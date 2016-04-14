# -*- encoding : utf-8 -*-
require 'spec_helper'

describe GroupsController do
  describe :show do
    it "should assign @group" do
      @group = create_group("Layout Info Marked")

      get :show, id: @group.id
      assigns[:group].should == @group
    end
  end

  describe :index do
    it "should assign @group_types with the existing group types" do
      @group_type = GroupType.find_or_create_by_description("Dummy group type")

      get :index
      assigns[:group_types].should == [@group_type]
    end
  end

  describe :new do
    it "should return new record" do
      get :new
      assigns[:group].should be_new_record
    end
  end

  describe :create do
    describe "success" do
      before(:each) do
        @group = mock_model(Group).as_null_object
        @group.should_receive(:save).and_return(true)

        Group.should_receive(:new).at_least(:once).and_return(@group)
        post :create
      end

      it "should redirect to group page" do
        response.should redirect_to(groups_path)
      end

      it "should set success flash" do
        flash[:success].should_not be_nil
      end
    end

    describe "failure" do
      before(:each) do
        @group = mock_model(Group).as_null_object
        @group.should_receive(:save).and_return(false)

        Group.should_receive(:new).at_least(:once).and_return(@group)
        post :create
      end

      it "should assign group" do
        assigns[:group].should == @group
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should re-render group creation form" do
        response.should render_template(:new)
      end
    end
  end

  describe :update do
    before(:each) do
      @group = create_group("Layout Info Marked")
    end

    describe "success" do
      before(:each) do
        Group.stub(:find).with(:all).and_return([])

        Group.should_receive(:find).with(@group.id.to_s).and_return(@group)
        @group.should_receive(:update_attributes).and_return(true)
        post :update, id: @group.id
      end

      it "should redirect to group page" do
        response.should redirect_to(groups_path)
      end

      it "should set success flash" do
        flash[:success].should_not be_nil
      end
    end

    describe "failure" do
      before(:each) do
        Group.stub(:find).with(:all).and_return([])

        Group.should_receive(:find).with(@group.id.to_s).and_return(@group)
        @group.should_receive(:update_attributes).and_return(false)

        post :update, id: @group.id
      end

      it "should assign group" do
        assigns[:group].should == @group
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should re-render group edit form" do
        response.should render_template(:edit)
      end
    end
  end
end
