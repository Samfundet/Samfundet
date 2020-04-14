# frozen_string_literal: true

class AdmissionsAdmin::JobApplicationsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'

  def show
    @log_entries = LogEntry.where(
      applicant_id: @job_application.applicant.id,
      admission_id: @job_application.job.admission.id,
      group_id: @job_application.job.group.id
    )
    @possible_log_entries = LogEntry.possible_log_entries
  end

  def hidden_create
    applicant = Applicant.find_by(email: params[:email])
    if applicant.nil?
      flash[:error] = t('admissions_admin.add_applicant_not_found')
    else
      job_application = JobApplication.new(applicant_id: applicant.id, motivation: 'Manuelt lagt til av Web', job_id: params[:job_id])
      if job_application.save
	flash[:success] = t('admissions_admin.add_applicant_success')
      else
        flash[:error] = t('admissions_admin.add_applicant_error')
      end
    end
    redirect_to admissions_admin_admission_group_job_path(admission_id: params[:admission_id], id: params[:job_id], group_id: params[:group_id])
  end
end
