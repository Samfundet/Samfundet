# frozen_string_literal: true

class AdmissionsAdmin::GroupsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'

  def show
    @group = Group.find(params[:id])
    @admission = Admission.find(params[:admission_id])
    @jobs = @group.jobs.where(admission: @admission)
    job_applications = @jobs.map(&:job_applications).flatten
    @should_show_delete_button = @jobs.map { |job| job.job_applications.exists? }.include? false

    @n_applications = job_applications.length
    @n_jobs = @jobs.length
    @n_applicants = @jobs.map(&:applicants).flatten.uniq.length

    admission_start = @admission.shown_from.to_date
    admission_end = @admission.actual_application_deadline.to_date
    applications_per_day = (admission_start..admission_end).map do |day|
      job_applications.count { |a| a.created_at.to_date == day.to_date }
    end

    @applications_per_day = (admission_start..admission_end).zip(applications_per_day)

    @applications_per_day_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series(data: applications_per_day, type: 'spline', name: 'Applications per day')
      f.yAxis(title: { text: 'Applications' }, allowDecimals: false)
      f.xAxis(title: { text: 'Days' }, categories: (admission_start..admission_end).map(&:to_s))
    end
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
