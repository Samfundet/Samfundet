# frozen_string_literal: true

class AdmissionsAdmin::AdmissionsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'

  has_control_panel_applet :admin_applet,
                           if: -> { can? :show, Admission }


  def show
    # CHECK IF THIS WORKS wITH MULTIPLE BEFORE MERGE
    @my_groups = Group.accessible_by(current_ability, :show)
    @job_application = JobApplication.new

    if @my_groups.length == 1
      redirect_to admissions_admin_admission_group_path(@admission, @my_groups.first)
    end
  end

  def statistics
    @campuses = Campus.order(:name)
    @campus_count = Campus.number_of_applicants_given_admission(@admission)

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

    applications_per_campus = @campuses.map do |campus|
      @campus_count[campus.id]
    end
    # Want both the name of the campus, and amount of applicants
    campus_labels = @campuses.map do |campus|
      "#{campus.name} - #{@campus_count[campus.id]}"
    end

    # The Gchart methods return an external URL to an image of the chart.
    @applications_per_group_chart = Gchart.pie(
      data: applications_per_group,
      encoding: 'text',
      labels: group_labels,
      size: '800x300',
      custom: 'chco=00FFFF,FF0000,FFFF00,0000FF', # color scale
    )

    @applications_per_campus_chart = Gchart.pie(
      data: applications_per_campus,
      encoding: 'text',
      labels: campus_labels,
      size: '800x350',
      custom: 'chco=00FFFF,FF0000,FFFF00,0000FF'
    )

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

  def admin_applet
    @admissions = Admission.current
  end

end
