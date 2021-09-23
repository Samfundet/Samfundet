# frozen_string_literal: true

class AdmissionsAdmin::InterviewTimeSlotsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'

  def validate_access(group)
    current_user.roles.each do |role|
      if role.name == 'Superuser' || role.name == 'mg_nestleder'
        return
      elsif role.name == 'Opptaksansvarlig' || role.name == 'Gjengsjef'
        if role.group.name == group.name
          return
        end
      end
    end
    redirect_back(fallback_location: root_path)
    flash[:error] = t('errors.illegal_path')
  end

  def validate_path(interview_time_slot)
    job_id = @interview_time_slot.job_id.to_s
    group_id = @interview_time_slot.group_id.to_s
    admission_id = @interview_time_slot.admission_id.to_s

    if params[:job_id] != job_id || params[:group_id] != group_id || params[:admission_id] != admission_id
      redirect_to admissions_admin_admission_group_job_interview_time_slots_path(job_id: job_id, group_id: group_id, admission_id: admission_id)
      flash[:error] = t('errors.illegal_path')
    end
  end

  def index
    @interview_time_slots = InterviewTimeSlot.where(job_id: request[:job_id], group_id: request[:group_id], admission_id: request[:admission_id])
    if @interview_time_slots.length > 0
      @interview_time_slot = @interview_time_slots.first
      @group = @interview_time_slot.group
      validate_path(@interview_time_slot)
      validate_access(@group)
    end
  end

  def show
    redirect_to edit_admissions_admin_admission_group_job_interview_time_slot_path
  end

  def new
    @interview_time_slot = InterviewTimeSlot.new
  end

  def edit
    @interview_time_slot = InterviewTimeSlot.find(params[:id])
    @group = @interview_time_slot.group
    validate_path(@interview_time_slot)
    validate_access(@group)
  end

  def create
    @interview_time_slot = InterviewTimeSlot.new(interview_time_slot_params)
    @interview_time_slot.job_id = request[:job_id]
    @interview_time_slot.group_id = request[:group_id]
    @interview_time_slot.admission_id = request[:admission_id]

    @group = @interview_time_slot.group
    validate_access(@group)

    if @interview_time_slot.save
      flash[:success] = 'Intervjutidsrom opprettet'
      redirect_to admissions_admin_admission_group_job_interview_time_slots_path
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def update
    @interview_time_slot = InterviewTimeSlot.find(params[:id])
    @group = @interview_time_slot.group
    validate_path(@interview_time_slot)
    validate_access(@group)

    if @interview_time_slot.update(interview_time_slot_params)
      redirect_to admissions_admin_admission_group_job_interview_time_slots_path
      flash[:success] = 'Intervjutidsrom oppdatert'
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @interview_time_slot = InterviewTimeSlot.find(params[:id])
    @group = @interview_time_slot.group
    validate_path(@interview_time_slot)
    validate_access(@group)

    @interview_time_slot.destroy
    redirect_to admissions_admin_admission_group_job_interview_time_slots_path
    flash[:success] = 'Intervjutidsrom slettet'
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
