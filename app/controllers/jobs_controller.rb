# -*- encoding : utf-8 -*-
class JobsController < ApplicationController
  layout "admissions"

  def show
    @job = Job.find(params[:id])
    @available_jobs_in_same_group = @job.available_jobs_in_same_group
    @similar_available_jobs = @job.similar_available_jobs

    # FIXME: Probably some role check is better.
    @job_application = if current_user.kind_of? Applicant
                         @job.job_applications.find_or_initialize_by_applicant_id(current_user.id)
                       else
                         JobApplication.new(job: @job)
                       end

    @already_applied = !@job_application.new_record?

    flash.now[:notice] = t('jobs.belongs_to_closed_admission') unless @job.admission.appliable?

    # Intercept AJAX requests
    render layout: false, partial: 'modal' if request.xhr?
  end
end
