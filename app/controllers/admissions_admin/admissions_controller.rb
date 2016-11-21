# -*- encoding : utf-8 -*-
# frozen_string_literal: true
class AdmissionsAdmin::AdmissionsController < ApplicationController
  layout 'admissions'
  filter_access_to [:show, :statistics]

  def show
    @admission = Admission.find(params[:id])
    @my_groups = current_user.my_groups
    @job_application = JobApplication.new

    if @my_groups.length == 1
      redirect_to admissions_admin_admission_group_path(@admission, @my_groups.first)
    end
  end

  def statistics
    @admission = Admission.find(params[:id])

    # applications_count = @admission.job_applications.count
    applications_per_group = @admission.groups.map do |group|
      group.jobs.where(admission_id: @admission.id).map do |job|
        job.job_applications.count
      end.sum
    end
    group_labels = @admission.groups.map(&:name)

    admission_start = @admission.shown_from.to_date
    admission_end = @admission.actual_application_deadline.to_date
    applications_per_day = (admission_start..admission_end).map do |day|
      @admission.job_applications.where('DATE(job_applications.created_at) = ?',
                                        day).count
    end
    admission_day_labels = (admission_start..admission_end).map do |day|
      day.strftime('%-d.%-m')
    end

    # The Gchart methods return an external URL to an image of the chart.
    @applications_per_group_chart = Gchart.pie(
      data: applications_per_group,
      encoding: 'text',
      labels: group_labels,
      size: '800x300',
      custom: 'chco=00FFFF,FF0000,FFFF00,0000FF', # color scale
    )

    @applications_per_day_chart = Gchart.bar(
      data: applications_per_day,
      encoding: 'text',
      labels: admission_day_labels,
      axis_with_labels: %w(x y),
      axis_range: [nil, [0, applications_per_day.max, [applications_per_day.max / 10, 1].max]],
      size: '800x350',
      bar_color: 'A03033'
    )
  end
end
