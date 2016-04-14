# -*- encoding : utf-8 -*-
require 'spec_helper'

describe JobApplication do
  it_should_validate_presence_of :applicant, :job, :motivation

  it "should delegate title to job" do
    @title = "Random title"

    @job = mock_model(Job)
    @job.should_receive(:title).and_return(@title)

    @job_application = JobApplication.new(job: @job)
    @job_application.title.should == @title
  end

  it "should remove corresponding interview when destroying itself" do
    @job_application = JobApplication.create!(job: mock_model(Job), applicant: mock_model(Applicant), motivation: "I don't really want this job.")
    @job_application_id = @job_application.id
    @interview_id = @job_application.find_or_create_interview.id
    @job_application.destroy
    JobApplication.find_by_id(@job_application_id).should be_nil
    Interview.find_by_id(@interview_id).should be_nil
  end

  it "should not remove corresponding interview when deleting itself" do
    @job_application = JobApplication.create!(job: mock_model(Job), applicant: mock_model(Applicant), motivation: "I don't really want this job.")
    @job_application_id = @job_application.id
    @interview_id = @job_application.find_or_create_interview.id
    @job_application.delete
    JobApplication.find_by_id(@job_application_id).should be_nil
    Interview.find_by_id(@interview_id).should_not be_nil
  end
end
