# -*- encoding : utf-8 -*-
require 'spec_helper'

describe Admission do
  before(:each) do
    @valid_attributes = {
      title: "value for title",
      shown_from: Time.current,
      shown_application_deadline: 1.week.from_now,
      actual_application_deadline: 1.week.from_now + 4.hours,
      user_priority_deadline: 2.weeks.from_now,
      admin_priority_deadline: 2.weeks.from_now + 1.hour
    }
  end

  it "should create a new instance given valid attributes" do
    Admission.create!(@valid_attributes)
  end

  describe :has_open_admissions? do
    it "should return true if there are any open admissions" do
      @open_admission = create_open_admission

      Admission.has_open_admissions?.should be_true
    end

    it "should return true if there are any open admissions" do
      @recent_admission = create_admission(
        title: "Recent admission",
        shown_from: 2.weeks.ago - 1.hour,
        shown_application_deadline: 2.weeks.ago
      )

      Admission.has_open_admissions?.should be_false
    end
  end

  it_should_validate_presence_of :title,
                                 :shown_from,
                                 :shown_application_deadline,
                                 :actual_application_deadline,
                                 :user_priority_deadline,
                                 :admin_priority_deadline

  context :with_realistic_data do
    before(:each) do
      @old_admission = create_admission(
        title: "Old admission",
        shown_from: 1.year.ago - 1.hour,
        shown_application_deadline: 1.year.ago
      )
      @recent_admission = create_admission(
        title: "Recent admission",
        shown_from: 2.weeks.ago - 1.hour,
        shown_application_deadline: 2.weeks.ago,
        user_priority_deadline: 2.weeks.ago + 3.days
      )
      @current_admission = create_admission(
        title: "Current admission",
        shown_from: 1.hour.ago,
        shown_application_deadline: 1.week.from_now,
        user_priority_deadline: 2.weeks.from_now
      )
      @prioritizable_admission = create_admission(
        title: "Prioriterbart opptak",
        shown_from: 3.hours.ago,
        shown_application_deadline: 2.hours.ago,
        actual_application_deadline: 1.hour.ago,
        user_priority_deadline: 3.days.from_now
      )
      @upcoming = @not_shown_on_frontpage = create_admission(
        title: "Not on frontpage",
        shown_from: 1.day.from_now
      )
    end

    describe :appliable? do
      it "should be true before the shown application deadline" do
        @admission = Admission.new(shown_application_deadline: 1.minute.from_now,
                                   actual_application_deadline: 1.hour.from_now,
                                   shown_from: 1.day.ago)
        @admission.appliable?.should be_true
      end

      it "should be true just after the shown application deadline" do
        @admission = Admission.new(shown_application_deadline: 1.minute.ago,
                                   actual_application_deadline: 1.hour.from_now,
                                   shown_from: 1.day.ago)
        @admission.appliable?.should be_true
      end

      it "should be false some time after the shown application deadline" do
        @admission = Admission.new(actual_application_deadline: 1.minute.ago,
                                   shown_from: 1.day.ago)
        @admission.appliable?.should be_false
      end

      it "should only contain admissions shown on frontpage" do
        @admission = Admission.new(actual_application_deadline: 1.minute.from_now,
                                   shown_from: 1.day.from_now)
        @admission.appliable?.should be_false
      end
    end

    describe "scopes" do
      it "should have a scope with admissions that are no longer appliable" do
        Admission.no_longer_appliable.should_not include(@current_admission,
                                                         @not_shown_on_frontpage)
        Admission.no_longer_appliable.should include(@old_admission,
                                                     @recent_admission,
                                                     @prioritizable_admission)
      end

      it "should have a scope with current admissions" do
        Admission.current.should include(@recent_admission,
                                         @current_admission,
                                         @prioritizable_admission,
                                         @not_shown_on_frontpage)
        Admission.current.should_not include(@old_admission)
      end

      it "should have a scope with upcoming admissions" do
        Admission.upcoming.should_not include(@old_admission,
                                              @recent_admission,
                                              @current_admission,
                                              @prioritizable_admission)
        Admission.upcoming.should include(@upcoming)
      end

      describe :appliable do
        it "should contain appliable admissions and not old ones" do
          Admission.appliable.should include(@current_admission)
          Admission.appliable.should_not include(@old_admission)
        end

        it "should not contain admissions that are not shown on front page" do
          Admission.appliable.should_not include(@not_shown_on_frontpage)
        end

        it "should only contain appliable admissions" do
          Admission.appliable.all?(&:appliable?).should be_true
        end

        it "should contain all appliable admissions" do
          outside = (Admission.all - Admission.appliable)
          outside.any?(&:appliable?).should be_false
        end
      end
    end

    describe :groups do
      before(:each) do
        @group_type = mock_model(GroupType)
      end

      it "should return groups ordered by name" do
        %w(X A G Z).each do |group_name|
          create_group_with_jobs_for_admission(group_name, 1, @current_admission)
        end
        @current_admission.groups.should == @current_admission.groups.sort_by(&:name)
      end

      it "should not show duplicate groups" do
        %w(X Y Z).each do |group_name|
          create_group_with_jobs_for_admission(group_name, 2, @current_admission)
        end
        @current_admission.groups.should == @current_admission.groups.uniq
      end

      def create_group_with_jobs_for_admission(group_name, num_jobs, admission)
        group = Group.create!(name: group_name, group_type: @group_type)
        num_jobs.times do
          group.jobs.create(
            title_no: "Job",
            teaser_no: "Haha",
            description_no: "HARDO GAY!",
            admission: admission
          )
        end
      end
    end

    describe :interview_dates do
      it "should return dates from after application deadline up to priority deadline" do
        @admission = Admission.new(actual_application_deadline: "2010-08-23 23:59:59",
                                   user_priority_deadline: "2010-08-27 23:59:59")

        @admission.should have(4).interview_dates
        @admission.interview_dates.first.should == Date.new(2010, 8, 24)
        @admission.interview_dates.last.should  == Date.new(2010, 8, 27)
      end
    end
  end
end
