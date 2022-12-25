# frozen_string_literal: true

class AdmissionsAdmin::InterviewGroupsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  before_action :load_info

  def index
    @interview_groups = InterviewGroup.where(admission: @admission, group: @group)
  end

  def show
    @interview_group = InterviewGroup.find(params[:id])
  end

  def show_unprocessed
    @applicants = @interview_group.applicants_for_interview_group
    @job_applications = []

    @applicants.each do |applicant|
      @job_applications.push(applicant.top_priority_job_application)
    end

    render partial: '_applicants'
  end

  def new
    @interview_group = InterviewGroup.new
    @available_jobs = @group.jobs - @interview_group.jobs

    puts()
    puts('GILS NUSTAV')
    puts()
  end

  def create
  end

  def edit
    @interview_group = InterviewGroup.find(params[:id])
    @available_jobs = @group.jobs - @interview_group.jobs

    puts()
    puts('GILS NUSTAV')
    puts()
  end

  def update
  end

  def set_interview
  end

private

  def load_info
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:group_id])
  end
end
