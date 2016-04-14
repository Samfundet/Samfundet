# -*- encoding : utf-8 -*-
require 'spec_helper'

describe AdmissionsAdmin::InterviewsController do
  before :each do
    @open_admission = create_open_admission
    @group = Group.create!(name: "Gruppe", group_type: mock_model(GroupType))
    @job = Job.create!(title_no: "Job 1",
                       teaser_no: "Yay",
                       description_no: "dsfdsf",
                       admission: @open_admission,
                       group: @group)
    @job_application = JobApplication.create!(
      motivation: "Jeg vil!",
      priority: 1,
      applicant: mock_model(Applicant),
      job: @job
    )
  end

  describe :update do
    before :each do
      @interview = Interview.create!(
        time: 5.hours.from_now,
        job_application: @job_application
      )
    end

    it "should update an interview object when passed appropriate data" do
      # FIXME: This test sometimes fails due to an off-by-one-second error.
      pending

      time = 1.hour.from_now

      put :update, admission_id: @open_admission.id, group_id: @group.id,
                   id: @interview.id, time: time, format: 'json'

      @interview.time = time

      response.body.should include(@interview.to_json)
    end
  end
end
