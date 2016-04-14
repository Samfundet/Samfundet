# -*- encoding : utf-8 -*-
require 'spec_helper'

describe ApplicationHelper, "when using html-helpers" do
  describe :title do
    it "should set content for title" do
      helper.should_receive(:content_for).with(:title)
      helper.title("Hello, world")
    end
  end

  describe :Translate do
    before do
      @test_text = "test text"
      I18n.should_receive(:translate).and_return(@test_text)
    end

    it "should return capitalized text" do
      helper.translate_and_capitalize('some_key').should == @test_text.capitalize
    end
  end

  describe :display_flash do
    it "should not display anything with no input" do
      helper.display_flash.should be_empty
    end

    it "should display flash notice when flash is initiated" do
      flash[:notice] = "A notice"

      helper.display_flash.should_not be_empty
    end

    it "should display a link for hiding the flash" do
      flash[:success] = "VICTORY!"

      helper.display_flash.should have_selector("a[class='hide']")
    end

    # integration-ish... Sounds like a job for.. CUCUMBER!
    it "should display flash for each type" do
      ApplicationHelper::FLASH_TYPES.each do |name|
        flash[name] = "message"

        helper.display_flash.should have_content("message")
        helper.display_flash.should have_selector(".flash-#{name.to_s}")

        flash[name] = nil
      end
    end
  end
end
