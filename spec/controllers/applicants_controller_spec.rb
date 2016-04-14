# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicantsController do
  describe :new do
    it "should return new record" do
      get :new
      assigns[:applicant].should be_new_record
    end
  end

  describe :create do
    describe "when successful" do
      before(:each) do
        @applicant_fields = {
          firstname: "Jonas",
          surname: "Dust",
          phone: "+47 10 20 30 40",
          email: "user@acme.org",
          password: "suppe",
          password_confirmation: "suppe"
        }

        @applicant = mock_model(Applicant)
        @applicant.stub(:phone).and_return(@applicant_fields[:phone])
        @applicant.should_receive(:save).and_return(true)

        Applicant.should_receive(:new).at_least(:once).and_return(@applicant)
        Applicant.stub(:find).with(@applicant.id).and_return(@applicant)
      end

      def post_create
        post :create, applicant: @applicant_fields
      end

      it "should redirect to the admissions page" do
        post_create
        response.should redirect_to(admissions_path)
      end

      it "should set success flash" do
        post_create
        flash[:success].should_not be_nil
      end

      it "should log in the applicant" do
        post_create
        session[:applicant_id].should == @applicant.id
      end

      it_should_behave_like "login with pending application"
    end

    describe "when invalid" do
      before(:each) do
        @applicant = mock_model(Applicant)
        @applicant.should_receive(:save).and_return(false)
        @applicant.stub(:phone).and_return('string')

        Applicant.should_receive(:new).at_least(:once).and_return(@applicant)

        post :create
      end

      it "should assign applicant" do
        assigns[:applicant].should == @applicant
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should re-render registration form" do
        response.should render_template(:new)
      end
    end

    describe "when a valid-looking phone number is entered" do
      it "should not set flash[:notice]" do
        @applicant = mock_model(Applicant)
        @phone = mock("PhoneAttribute")
        @phone.stub(:match).and_return(true)
        @applicant.stub(:phone).and_return(@phone)
        @applicant.stub(:save).and_return(true)

        Applicant.should_receive(:new).at_least(:once).and_return(@applicant)

        post :create

        flash[:notice].should be_nil
      end
    end

    describe "when an invalid-looking phone number is entered" do
      it "should set flash[:notice]" do
        @applicant = mock_model(Applicant)
        @phone = mock("PhoneAttribute")
        @phone.stub(:match).and_return(false)
        @applicant.stub(:phone).and_return(@phone)
        @applicant.stub(:save).and_return(true)

        Applicant.should_receive(:new).at_least(:once).and_return(@applicant)

        post :create

        flash[:notice].should_not be_nil
      end
    end
  end

  describe :show do
    it "should assign applicant" do
      @applicant = mock_model(Applicant)
      Applicant.should_receive(:find).at_least(:once).and_return(@applicant)
      get :show, id: @applicant.id
      assigns[:applicant].should == @applicant
    end
  end

  describe :generate_forgot_password_email do
    describe "email failure" do
      before(:each) do
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(nil)

        post :generate_forgot_password_email
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should redirect to forgot password" do
        response.should redirect_to forgot_password_path
      end
    end

    describe "limit failure" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(@applicant)
        @applicant.should_receive(:can_recover_password?).at_least(:once).and_return(false)

        post :generate_forgot_password_email
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should redirect to forgot password" do
        response.should redirect_to forgot_password_path
      end
    end

    describe "recovery_hash failure" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(@applicant)
        @applicant.should_receive(:can_recover_password?).and_return(true)
        @applicant.stub(:create_recovery_hash).and_return('hash')
        PasswordRecovery.stub(:create!).and_return(false)

        post :generate_forgot_password_email
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should redirect to forgot password" do
        response.should redirect_to forgot_password_path
      end
    end

    describe "email delivery failure" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(@applicant)
        @applicant.should_receive(:can_recover_password?).and_return(true)
        @applicant.stub(:create_recovery_hash).and_return('hash')
        @applicant.stub(:email).and_return('email')
        @applicant.stub(:full_name).and_return('Full Name')
        @applicant.stub_chain(:password_recoveries, :last, :recovery_hash).and_return('hash')
        PasswordRecovery.stub(:create!).and_return(true)
        @message = mock_model("Message")
        ForgotPasswordMailer.stub(:forgot_password_email).and_return(@message)
        @message.should_receive(:deliver).and_raise(NoMethodError)

        post :generate_forgot_password_email
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should redirect to forgot password" do
        response.should redirect_to forgot_password_path
      end
    end

    describe "success" do
      before(:each) do
         @applicant = mock_model(Applicant)
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(@applicant)
        @applicant.should_receive(:can_recover_password?).and_return(true)
        @applicant.should_receive(:create_recovery_hash).at_least(:once).and_return('hash')
        @applicant.stub(:email).and_return('email')
        @applicant.stub(:full_name).and_return('Full Name')
        @applicant.stub_chain(:password_recoveries, :last, :recovery_hash).and_return('hash')
        PasswordRecovery.stub(:create!).and_return(true)
        @message = mock_model("Message")
        ForgotPasswordMailer.stub(:forgot_password_email).and_return(@message)
        @message.should_receive(:deliver).and_return(@message)

        post :generate_forgot_password_email
      end

      it "should set success flash" do
        flash[:success].should_not be_nil
      end

      it "should redirect to forgot password" do
        response.should redirect_to forgot_password_path
      end
    end
  end

  describe :reset_password do
    describe "email failure" do
      before(:each) do
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(nil)

        get :reset_password
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should not return applicant" do
        assigns[:applicant].should be_nil
      end
    end

    describe "hash failure" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(@applicant)
        @applicant.should_receive(:check_hash).at_least(:once).and_return(false)

        get :reset_password
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should not return applicant" do
        assigns[:applicant].should be_nil
      end
    end

    describe "success" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find_by_email).at_least(:once).and_return(@applicant)
        @applicant.should_receive(:check_hash).at_least(:once).and_return(true)
        @hash = "hash"

        get :reset_password, hash: @hash
      end

      it "should return applicant" do
        assigns(:applicant).should == @applicant
      end

      it "should return the hash" do
        assigns(:hash).should == @hash
      end
    end
  end

  describe :change_password do
    describe "failure to validate hash" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find).at_least(:once).and_return(@applicant)
        @applicant.stub(:check_hash).and_return(false)

        post :change_password, id: @applicant.id
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should render reset password" do
        response.should render_template(:reset_password)
      end
    end

    describe "failure to update" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find).at_least(:once).and_return(@applicant)
        @applicant.stub(:check_hash).and_return(true)
        @applicant.stub(:update_attributes).and_return(false)

        post :change_password, applicant: {}, id: @applicant.id
      end

      it "should set error flash" do
        flash[:error].should_not be_nil
      end

      it "should render reset password" do
        response.should render_template(:reset_password)
      end
    end

    describe "success" do
      before(:each) do
        @applicant = mock_model(Applicant)
        Applicant.should_receive(:find).at_least(:once).and_return(@applicant)
        @applicant.stub(:check_hash).and_return(true)
        @applicant.stub(:update_attributes).and_return(true)
        PasswordRecovery.create!(applicant_id: @applicant.id)

        post :change_password, applicant: {}, id: @applicant.id

      end

      it "should delete all password_recoveries" do
        @applicant.stub(:password_recoveries).and_return(PasswordRecovery.find_by_applicant_id(@applicant.id))
        @applicant.password_recoveries.should be_nil
      end
      it "should set success flash" do
        flash[:success].should_not be_nil
      end

      it "should redirect to login page" do
        response.should redirect_to login_path
      end
    end
  end


  describe :steal_identity do
    it "should set the session value applicant_id to the id of the applicant having the email specified and redirect to home page" do
	applicant = mock_model(Applicant).as_null_object
        Applicant.stub(:find_by_email).with("test@example.com").and_return(applicant)
	post :steal_identity, applicant_email: "test@example.com"
        session[:applicant_id].should == applicant.id
        response.should redirect_to(root_path)
    end
  end

end
