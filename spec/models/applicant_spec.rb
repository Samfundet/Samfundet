# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Applicant do
  it_should_validate_presence_of :firstname, :surname, :email, :phone

  it 'should have full name property' do
    @applicant = Applicant.new(firstname: "Torstein", surname: "Nicolaysen")
    @applicant.full_name.should == 'Torstein Nicolaysen'
  end

  describe :phone do
    before(:each) do
      @applicant = create_applicant
    end

    it "can contain +" do
      @applicant.phone = "12345678+"
      @applicant.valid?.should be_true
    end

    it "can contain whitespace" do
      @applicant.phone = "12345678  +"
      @applicant.valid?.should be_true
    end

    it "can not contain alphabetic characters" do
      @applicant.phone = "12345678  a+"
      @applicant.valid?.should be_false
    end
  end
end

describe Applicant, "when authenticating" do
  before do
    @email = "joe@example.com"
    @password = "secret"
    @password_confirmation = "secret"

    @applicant = create_applicant(email: @email, password: @password)
  end

  it "should return applicant given valid e-mail and password" do
    Applicant.authenticate(@email, @password).should == @applicant
  end

  it "should return nil given incorrect password" do
    Applicant.authenticate(@email, "incorrect-password").should be_nil
  end

  it "should return nil given incorrect email" do
    Applicant.authenticate("incorrect-email", @password).should be_nil
  end
end
