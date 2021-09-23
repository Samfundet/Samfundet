# frozen_string_literal: true

class UnavailableInterviewTimeSlotsController < ApplicationController
  load_and_authorize_resource

  def index
    @unavailable_interview_time_slots = UnavailableInterviewTimeSlot.where(applicant_id: current_user.id, admission_id: request[:admission_id])
    @unavailable_interview_time_slots.each do |i|
      puts(i.start_time)
      puts(i.end_time)
    end
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
    @interview_time_slot.applicant_id = request[:applicant_id]
    @interview_time_slot.admission_id = request[:admission_id]

    if @unavailable_interview_time_slot.save
      flash[:success] = 'Intervjutidsrom opprettet'
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
      flash[:success] = 'Intervjutidsrom oppdatert'
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @unavailable_interview_time_slot = UnavailableInterviewTimeSlot.find(params[:id])

    @unavailable_interview_time_slot.destroy
    redirect_to admission_unavailable_interview_time_slots_path
    flash[:success] = 'Intervjutidsrom slettet'
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
