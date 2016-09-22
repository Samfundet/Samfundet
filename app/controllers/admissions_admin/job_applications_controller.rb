# -*- encoding : utf-8 -*-
class AdmissionsAdmin::JobApplicationsController < ApplicationController
  layout 'admissions'
  filter_access_to :show, attribute_check: true

  def show
    @log_entries = LogEntry.where(
      applicant_id: @job_application.applicant.id,
      admission_id: @job_application.job.admission.id,
      group_id: @job_application.job.group.id
    )
    if I18n.locale == :no
      @possible_log_entries = [
        "Forsøkt ringt, tok ikke telefonen",
        "Ringt og tilbudt verv, venter på svar",
        "Ringt, venter fremdeles på svar",
        "Ringt og tilbudt verv, takket ja",
        "Ringt og tilbudt verv, takket nei",
        "Ringt og meddelt ingen tilbud om verv",
        "Sendt e-post og meddelt ingen tilbud om verv"
      ]
    elsif I18n.locale == :en
      @possible_log_entries = [
        "Called, no reply",
        "Called and offered position, awaiting reply",
        "Called, still waiting for reply",
        "Called and offered position, the applicant accepted",
        "Called and offered position, the applicant declined",
        "Called and notified the applicant of our rejection",
        "Sent email and notified the applicant of our rejection"
      ]
    end
  end

  def hidden_create
    applicant = Applicant.find_by(email: params[:email])
    if applicant.nil?
      flash[:error] = "Fant ikke søker"
      redirect_to admissions_admin_admission_group_job_path(admission_id: params[:admission_id], id: params[:job_id], group_id: params[:group_id])
    else
      job_application = JobApplication.new(applicant_id: applicant.id, motivation: "Manuelt lagt til av Web", job_id: params[:job_id])
      if job_application.save
        flash[:success] = "Suksess! Du la til en søker"
      else
        flash[:error] = "Noe gikk galt. Søknad ikke lagt til"
      end
      redirect_to admissions_admin_admission_group_job_path(admission_id: params[:admission_id], id: params[:job_id], group_id: params[:group_id])
    end
  end
end
