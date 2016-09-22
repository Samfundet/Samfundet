# -*- encoding : utf-8 -*-
class AdmissionsAdmin::LogEntriesController < ApplicationController
  before_filter :new_log_entry, only: :create
  filter_access_to [:create, :destroy], attribute_check: true

  def create
    @log_entry.log = params[:log_entry][:log]
    if @log_entry.save
      flash[:success] = "Loggføringen er lagt til."
    else
      flash[:error] = "Du er nødt til å fylle ut loggfeltet."
    end

    redirect_back
  end

  def destroy
    @log_entry.destroy
    flash[:success] = "Loggføringen er slettet."

    redirect_back
  end

  private

  def new_log_entry
    @admission = Admission.find params[:admission_id]
    @applicant = Applicant.find params[:applicant_id]
    @group = Group.find params[:group_id]

    @log_entry = LogEntry.new(
      admission: @admission,
      applicant: @applicant,
      group: @group,
      member: @current_user
    )
  end
end
