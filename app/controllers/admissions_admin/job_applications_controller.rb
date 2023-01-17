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
    @job_applications_in_group = @job_application.applicant.job_applications_at_group(@job_application.job.admission, @job_application.job.group)
  end

  def reset_status
    application = JobApplication.find(params[:job_application_id])
    if application != nil
      interview = application.find_or_create_interview
      interview.applicant_status = nil
      interview.save
      application.save
    end
    redirect_back(fallback_location: root_path)
  end

  def hidden_create
    applicant = Applicant.find_by(email: params[:email])
    if applicant.nil?
      flash[:error] = t('admissions_admin.add_applicant_not_found')
    else
      job_application = JobApplication.new(applicant_id: applicant.id, motivation: t('admissions_admin.add_applicant_motivation'), job_id: params[:job_id])
      if job_application.save
        flash[:success] = t('admissions_admin.add_applicant_success')
      else
        flash[:error] = t('admissions_admin.add_applicant_error')
      end
    end
    redirect_to admissions_admin_admission_group_job_path(admission_id: params[:admission_id], id: params[:job_id], group_id: params[:group_id])
  end
end
