# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Group do
  it_should_validate_presence_of :name

  it "should sort alphabetically" do
    groups = %w(Regi TIRC Klubbstyret Styret).map do |name|
      Group.new(name: name)
    end

    groups.sort.collect(&:name).should == %w(Klubbstyret Regi Styret TIRC)
  end

  describe :short_name do
    context "when called on a group without an abbreviation" do
      it "should return the name" do
        @group = Group.new(abbreviation: nil, name: "UKA-11")
        @group.short_name.should == @group.name
      end
    end

    context "when called on a group with abbreviation" do
      it "should return the abbreviation" do
        @group = Group.new(abbreviation: "LIM", name: "Layout Info Marked")
        @group.short_name.should == @group.abbreviation
      end
    end
  end

  describe :interviews do
    before(:each) do
      @applicant = create_applicant

      @group = create_group("Regi")
      @admission = create_open_admission
      @job = create_job("Kuling", @group, @admission)

      @job_application = JobApplication.create!(
        motivation: "Jeg er kul",
        job: @job,
        applicant: @applicant
      )
    end

    it "should only return interviews for the group" do
      @interview = Interview.create!(
        time: 2.hours.from_now,
        job_application: @job_application
      )

      @group.interviews.should include(@interview)
    end
  end

  describe "jobs in admissions" do
    context "when querying" do
      it "should return all the group's jobs in the admission" do
        @group = create_group("LIM")
        @admission = create_open_admission
        @job = create_job("Webutvikler", @group, @admission)

        @group.jobs_in_admission(@admission).should include(@job)
      end
    end
  end
end
