# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Job do
  before(:each) do
    @open_admission = create_open_admission
    @closed_admission = create_closed_admission
  end

  it_should_validate_presence_of :title_no, :description_no, :group

  it "should create a new instance given valid attributes" do
    create_job("title", mock_model(Group), mock_model(Admission))
  end

  it "should have default sorting by title" do
    titles = %w(Utvikler Danser Stønter Næringslivskontakt)
    titles.each { |t| create_job(t, mock_model(Group), mock_model(Admission)) }

    Job.all.collect(&:title).should == titles.sort
  end

  context "language" do
    before(:each) do
      @job = Job.create(
        title_no: "Norsk title",
        title_en: "Engelsk title",
        teaser_no: "Norsk teaser",
        teaser_en: "Engelsk teaser",
        description_no: "Norsk description",
        description_en: "Engelsk description",
        default_motivation_text_no: "Norsk motivasjon",
        default_motivation_text_en: "English motivation"
      )
    end
    context "with :no locale" do
      before(:each) do
        I18n.should_receive(:locale).at_least(:once).and_return(:no)
      end
      describe "title" do
        it "should be norwegian" do
          @job.title.should == @job.title_no
        end
      end
      describe "teaser" do
        it "should be norwegian" do
          @job.teaser.should == @job.teaser_no
        end
      end
      describe "description" do
        it "should be norwegian" do
          @job.description.should == @job.description_no
        end
      end
      describe "default motivation text" do
        it "should be norwegian" do
          @job.default_motivation_text.should == @job.default_motivation_text_no
        end
      end
    end

    context "with :en locale" do
      before(:each) do
        I18n.should_receive(:locale).at_least(:once).and_return(:en)
      end
      describe "title" do
        it "should be english" do
          @job.title.should == @job.title_en
        end
      end
      describe "teaser" do
        it "should be english" do
          @job.teaser.should == @job.teaser_en
        end
      end
      describe "description" do
        it "should be english" do
          @job.description.should == @job.description_en
        end
      end
      describe "default motivation text" do
        it "should be english" do
          @job.default_motivation_text.should == @job.default_motivation_text_en
        end
      end
    end
  end

  describe :assigned_applicants do
    before(:each) do
      @admission = create_open_admission

      @group = create_group("Markedsføringsgjengen")
      @job = create_job("Webdesigner", @group, @admission)

      @applicant = create_applicant
      @job_application = create_job_application(@job, @applicant)
    end

    context "wanted applicant with this job as first priority" do
      it "should include the applicant" do
        pending
        @job_application.update_attributes!(acceptance_status: :wanted)
        @job.assigned_applicants.should include(@applicant)
      end
    end

    context "could_take applicant with this job as first priority" do
      it "should not include the applicant" do
        pending
        @job_application.update_attributes!(acceptance_status: :could_take)
        @job.assigned_applicants.should_not include(@applicant)
      end
    end

    context "not_wanted applicant with this job as first priority" do
      it "should not include the applicant" do
        pending
        @job_application.update_attributes!(acceptance_status: :not_wanted)
        @job.assigned_applicants.should_not include(@applicant)
      end
    end

    context "wanted applicant who is wanted in a higher prioritized job" do
      it "should not include the applicant" do
        pending
        @job2 = create_job("DJ", create_group("Klubbstyret"), @admission)
        @job_application2 = create_job_application(@job2, @applicant)
        @job_application2.move_higher
        @job_application2.update_attributes!(acceptance_status: :wanted)

        @job_application.update_attributes!(acceptance_status: :wanted)

        @job.assigned_applicants.should_not include(@applicant)
      end
    end
  end

  describe :available_jobs_in_same_group do
    before(:each) do
      @group = Group.create!(group_type: stub_model(GroupType), name: "Layout Info Marked")
      @webutvikler = @group.jobs.create!(admission: @open_admission, title_no: "Webutvikler", teaser_no: "Yay", description_no: "Bzzt")
    end

    it "should return jobs in the same group" do
      @stunter     = @group.jobs.create!(admission: @open_admission, title_no: "Stunter", teaser_no: "Yay", description_no: "Yow")
      @webutvikler.available_jobs_in_same_group.should include(@stunter)
    end

    it "should not return jobs in closed admissions" do
      @layoutfrik = @group.jobs.create!(admission: @closed_admission, title_no: "Layoutfrik", teaser_no: "Yay", description_no: "Ough")
      @webutvikler.available_jobs_in_same_group.should_not include(@layoutfrik)
    end

    it "should not return the job-instance being queried" do
      @webutvikler.available_jobs_in_same_group.should_not include(@webutvikler)
    end
  end

  describe :similar_available_jobs do
    before(:each) do
      @lim = Group.create!(group_type: stub_model(GroupType), name: "Layout Info Marked")
      @webutvikler = @lim.jobs.create!(admission: @open_admission, title_no: "Webutvikler", teaser_no: "Yay", description_no: "Whatever",
                                       tags: [JobTag.find_or_create_by_title("utvikling")])
    end

    it "should return jobs with at least one matching tag" do
      @dusken = Group.create!(group_type: stub_model(GroupType), name: "Under Dusken")
      @sysutvikler = @dusken.jobs.create!(admission: @open_admission, title_no: "Systemutvikler", teaser_no: "Yay", description_no: "Whazzup",
                                          tags: [JobTag.find_or_create_by_title("utvikling")])

      @webutvikler.similar_available_jobs.should include(@sysutvikler)
    end

    it "should not return jobs in closed admissions" do
      @gammel_webutvikler = @lim.jobs.create(admission: @closed_admission, title_no: "Webutvikler", description_no: "Whatever",
                                             tags: [JobTag.find_or_create_by_title("utvikling")])

      @webutvikler.similar_available_jobs.should_not include(@gammel_webuvikler)
    end
  end
end
