# -*- encoding : utf-8 -*-
require 'spec_helper'

describe MemberSessionsController do
  describe :new do
    it "should render the login template" do
      get :new
      response.should render_template("new")
    end

    it "should set redirect path when specified" do
      @redirect_to = "/some/redirect/path"
      get :new, redirect_to: @redirect_to
      assigns[:redirect_to].should == @redirect_to
    end

    it "should not set the login_id" do
      get :new
      assigns[:member_login_id].should be_nil
    end

    describe ":active_admission" do
      it "should be true if there are active admissions" do
        @active_admission = stub_model(Admission)
        Admission.stub(:appliable).and_return([@active_admission])

        get :new
        assigns[:open_admissions_exist].should be_true
      end

      it "should be false when there are no active admissions" do
        Admission.stub(:appliable).and_return([])
        get :new
        assigns[:open_admissions_exist].should be_false
      end
    end
  end

  describe :create do
    before do
      @id = "billy.bob@samfundet.no"
      @password = "secret"
    end

    it "should attempt to authenticate with given username and password" do
      Member.should_receive(:authenticate).with(@id, @password)
      post :create, member_login_id: @id, member_password: @password
    end

    describe "when authenticated" do
      before(:each) do
        @member = mock_model(Member).as_null_object
        @member.should_receive(:full_name).and_return("Balle Klorin")

        Member.should_receive(:authenticate).and_return(@member)
      end

      it "should save member id in session" do
        post :create
        session[:member_id].should == @member.id
      end

      it "should remove applicant id from session" do
        session[:applicant_id] = 555

        post :create
        session[:applicant_id].should be_nil
      end

      it "should set success flash message" do
        post :create
        flash[:success].should_not be_nil
      end

      it "should by default redirect to the root" do
        post :create
        response.should redirect_to(root_path)
      end

      it "should redirect to specified path when set" do
        @path = "/some/random/path"
        post :create, redirect_to: @path
        response.should redirect_to(@path)
      end
    end

    context "when not authenticated" do
      before(:each) do
        Member.should_receive(:authenticate).and_return(nil)
        post :create, member_login_id: (@id = "member@example.com")
      end

      it "should not save member id in session" do
        session[:member_id].should be_nil
      end

      it "should set an error message" do
        flash[:error].should_not be_nil
      end

      it "should set the login_id from the failed attempt" do
        assigns[:member_login_id].should == @id
      end

      it "should render the login form" do
        response.should render_template("new")
      end
    end
  end
end
