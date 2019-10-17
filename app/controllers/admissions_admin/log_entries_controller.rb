# frozen_string_literal: true

class AdmissionsAdmin::LogEntriesController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  before_action :new_log_entry, only: :create

  def create
    @log_entry.log = params[:log_entry][:log]
    if @log_entry.save
      flash[:success] = 'Loggføringen er lagt til.'
    else
      flash[:error] = 'Du er nødt til å fylle ut loggfeltet.'
    end

    redirect_back(fallback_location: root_path)
  end

  def destroy
    @log_entry.destroy
    flash[:success] = 'Loggføringen er slettet.'

    redirect_back(fallback_location: root_path)
  end

  private

  def log_entry_params
    params.require(:log_entry).permit(:log)
  end

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
