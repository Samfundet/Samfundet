# frozen_string_literal: true

class AdmissionsAdmin::InterviewGroupsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource

  def index
    @interview_groups = InterviewGroup.where(admission: @admission, group: @group)
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def set_interview_time
  end
end
