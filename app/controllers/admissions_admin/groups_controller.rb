# -*- encoding : utf-8 -*-
class AdmissionsAdmin::GroupsController < ApplicationController
  j layout "admissions"

  filter_access_to [:show, :applications], attribute_check: true

  def show
    @admission = Admission.find(params[:admission_id])
    @jobs = @group.jobs.find_all_by_admission_id(@admission.id)
    job_applications = @jobs.map(&:job_applications).flatten

    admission_start = @admission.shown_from.to_date
    admission_end = @admission.actual_application_deadline.to_date
    applications_per_day = (admission_start..admission_end).map do |day|
      job_applications.count { |a| a.created_at.to_date === day.to_date }
    end
    admission_day_labels = (admission_start..admission_end).map do |day|
      day.strftime("%-d.%-m")
    end

    @applications_per_day_chart = Gchart.bar(
      data: applications_per_day,
      encoding: 'text',
      labels: admission_day_labels,
      axis_with_labels: %w(x y),
      axis_range: [nil, [0, applications_per_day.max, 1]],
      size: '800x350',
      bar_color: 'A03033'
    )
  end

  def applications
    @admission = Admission.find(params[:admission_id])

    job_applications = @admission.job_applications.find(:all, conditions: ['group_id = ?', @group.id])
    job_application_groupings = job_applications.group_by do |job_application|
      job_application.applicant.full_name.downcase
    end
    @job_application_groupings = job_application_groupings.values
  end
end
