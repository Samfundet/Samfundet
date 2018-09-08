# frozen_string_literal: true

class AdmissionsAdmin::GroupsController < ApplicationController
  layout 'admissions'

  filter_access_to %i[show applications reject_calls], attribute_check: true

  def show
    @admission = Admission.find(params[:admission_id])
    @jobs = @group.jobs.where(admission: @admission)
    job_applications = @jobs.map(&:job_applications).flatten

    admission_start = @admission.shown_from.to_date
    admission_end = @admission.actual_application_deadline.to_date
    applications_per_day = (admission_start..admission_end).map do |day|
      job_applications.count { |a| a.created_at.to_date == day.to_date }
    end
    admission_day_labels = (admission_start..admission_end).map do |day|
      day.strftime('%-d.%-m')
    end

    @applications_per_day_chart = Gchart.bar(
      data: applications_per_day,
      encoding: 'text',
      labels: admission_day_labels,
      axis_with_labels: %w[x y],
      axis_range: [nil, [0, applications_per_day.max, [applications_per_day.max / 10, 1].max]],
      size: '800x350',
      bar_color: 'A03033'
    )
  end

  def applications
    @admission = Admission.find(params[:admission_id])

    job_applications = @admission.job_applications.includes(:job).where("jobs.group_id": @group.id)
    job_application_groupings = job_applications.group_by do |job_application|
      job_application.applicant.full_name.downcase
    end
    @job_application_groupings = job_application_groupings.values
    respond_to do |format|
      format.html
      format.csv do
        response.headers['Content-Disposition'] = "attachment; filename='#{@admission.title}-#{@group.name}-#{Date.current}.csv'"
      end
    end
  end

  def reject_calls
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:id])
    @applicants_to_call = @group.applicants_to_call(@admission).sort_by(&:full_name)
  end
end
