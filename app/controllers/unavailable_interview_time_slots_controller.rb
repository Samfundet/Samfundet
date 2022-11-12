# frozen_string_literal: true

class UnavailableInterviewTimeSlotsController < ApplicationController
  before_action :check_if_applicant
  load_and_authorize_resource

  def check_if_applicant
    if !current_user.is_applicant
      invalid_path
    end
  rescue
    invalid_path
  end

  def index
    @admission = Admission.first
    @unavailable_interview_time_slots = current_user.unavailable_interview_time_slots.where(admission_id: Admission.first)
  end

  def show
    redirect_to edit_admission_unavailable_interview_time_slot_path
  end

  def new
    @unavailable_interview_time_slot = UnavailableInterviewTimeSlot.new
  end

  def edit
    @unavailable_interview_time_slot = UnavailableInterviewTimeSlot.find(params[:id])
  end

  def create
    @unavailable_interview_time_slot = UnavailableInterviewTimeSlot.new(unavailable_interview_time_slot_params)
    @interview_time_slot.applicant_id = current_user.id
    @interview_time_slot.admission_id = request[:admission_id]

    if @unavailable_interview_time_slot.save
      flash[:success] = t('unavailable_interview_time_slots.messages.created')
      redirect_to admission_unavailable_interview_time_slots_path
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def update
    @unavailable_interview_time_slot = UnavailableInterviewTimeSlot.find(params[:id])

    if @unavailable_interview_time_slot.update(unavailable_interview_time_slot_params)
      redirect_to admission_unavailable_interview_time_slots_path
      flash[:success] = t('unavailable_interview_time_slots.messages.updated')
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @unavailable_interview_time_slot = UnavailableInterviewTimeSlot.find(params[:id])
    @unavailable_interview_time_slot.destroy

    redirect_to admission_unavailable_interview_time_slots_path
    flash[:success] = t('unavailable_interview_time_slots.messages.deleted')
  end

private

  def unavailable_interview_time_slot_params
    params.require(:unavailable_interview_time_slot).permit(
      :applicant_id,
      :admission_id,
      :start_time, :end_time,
    )
  end
end
