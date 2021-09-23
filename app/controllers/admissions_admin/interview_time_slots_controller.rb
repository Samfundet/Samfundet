# frozen_string_literal: true

class AdmissionsAdmin::InterviewTimeSlotsController < AdmissionsAdmin::BaseController
  before_action :validate_access
  load_and_authorize_resource
  layout 'admissions'

  def validate_access
    @job = Job.find_by(id: request[:job_id])
    @group = Group.find_by(id: request[:group_id])
    @admission = @job.admission
    current_user.roles.each do |role|
      if role.title == 'lim_web' or role.title.include? 'mg_nestleder'
        return
      elsif role.title.include? 'opptaksansvarlig' or role.title.include? 'gjengsjef'
        if role.group.name == @group.name
          return
        end
      end
    end
    permission_denied
  rescue
    invalid_path
  end

  def index
    @interview_time_slots = InterviewTimeSlot.where(job_id: @job.id, group_id: @group.id, admission_id: @admission.id)
  end

  def show
    @interviews = @interview_time_slot.interviews
    @date = @interview_time_slot.start_time.to_date
  end

  def new
    @interview_time_slot = InterviewTimeSlot.new
  end

  def edit
    @interview_time_slot = InterviewTimeSlot.find(params[:id])
  end

  def create
    @interview_time_slot = InterviewTimeSlot.new(interview_time_slot_params)
    @interview_time_slot.job_id = @job.id
    @interview_time_slot.group_id = @group.id
    @interview_time_slot.admission_id = @admission.id

    if @interview_time_slot.save
      flash[:success] = t('interview_time_slots.messages.created')
      redirect_to admissions_admin_admission_group_job_interview_time_slots_path
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def update
    @interview_time_slot = InterviewTimeSlot.find(params[:id])

    if @interview_time_slot.update(interview_time_slot_params)
      redirect_to admissions_admin_admission_group_job_interview_time_slots_path
      flash[:success] = t('interview_time_slots.messages.updated')
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @interview_time_slot = InterviewTimeSlot.find(params[:id])

    if @interview_time_slot.number_of_interviews > 0
      redirect_back(fallback_location: root_path)
      flash[:error] = t('errors.illegal_path')
      return
    end

    @interview_time_slot.destroy

    redirect_to admissions_admin_admission_group_job_interview_time_slots_path
    flash[:success] = t('interview_time_slots.messages.deleted')
  end


private

  def interview_time_slot_params
    params.require(:interview_time_slot).permit(
      :job_id,
      :group_id,
      :admission_id,
      :location,
      :comment,
      :start_time, :end_time,
    )
  end
end
