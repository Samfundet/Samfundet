# frozen_string_literal: true

class AdmissionsAdmin::AdmissionsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'

  before_action :find_by_id, only: %i[edit update]

  has_control_panel_applet :admin_applet,
                           if: -> { can? :show, Admission }

  def show
    @my_groups = Group.accessible_by(current_ability, :show)
    @job_application = JobApplication.new

    redirect_to admissions_admin_admission_group_path(@admission, @my_groups.first) if @my_groups.length == 1
  end

  def new
    @admission = Admission.new
  end

  def create
    @admission = Admission.new(admission_params)
    if @admission.save
      flash[:success] = t('admissions.registration_success')
      redirect_to admissions_path
    else
      flash[:error] = t('admissions.registration_error')
      render :new
    end
  end

  def edit
  end

  def update
    if @admission.update_attributes(admission_params)
      flash[:success] = t('admissions_admin.admission_updated')
      redirect_to admissions_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

  def statistics
    @campuses = Campus.order(:name)
    @campus_count = Campus.number_of_applicants_given_admission(@admission)

    count_unique_applicants


    @applications_per_group = @admission.groups.map do |group|
      count = group.jobs.where(admission_id: @admission.id).map do |job|
        job.job_applications.count
      end.sum
      ["#{group.name} - #{count}", count]
    end

    @applicants_per_campus = @campuses.map do |campus|
      count = @campus_count[campus.id]
      ["#{campus.name} - #{count}", count]
    end

    applications_per_group_chart
    applicants_per_campus_chart
    applications_per_day_chart
  end

  def admin_applet
    @admissions = Admission.current
  end

protected

  def find_by_id
    @admission = Admission.find(params[:id])
  end

  def admission_params
    params.require(:admission).permit(:title, :shown_from, :shown_application_deadline, :actual_application_deadline, :user_priority_deadline, :admin_priority_deadline, :groups_with_separate_admission, :promo_video)
  end

private

  def applications_per_day_chart
    admission_start = @admission.shown_from.to_date
    admission_end = @admission.actual_application_deadline.to_date
    applications_per_day = (admission_start..admission_end).map do |day|
      @admission.job_applications.where('DATE(job_applications.created_at) = ?',
                                        day).count
    end

    @applications_per_day = (admission_start..admission_end).zip(applications_per_day)

    @applications_per_day_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series(data: @applications_per_day, type: 'spline', name: t('admissions_admin.applications'))
      f.yAxis(title: { text: t('admissions_admin.applications') }, allowDecimals: false)
      f.xAxis(title: { text: t('admissions_admin.days') }, categories: (admission_start..admission_end).map(&:to_s))
    end
  end

  def applicants_per_campus_chart
    @applicants_per_campus_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart(defaultSeriesType: 'pie', margin: [50, 200, 60, 170])
      series = {
        type: 'pie',
        name: t('admissions_admin.applicants'),
        data: @applicants_per_campus
      }
      f.series(series)
      f.options[:title][:text] = t('admissions_admin.applications_by_campus')
      f.legend(layout: 'vertical', style: { left: 'auto', bottom: 'auto', right: '50px', top: '100px' })
      f.plot_options(pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          color: 'black',
        }
      })
    end
  end

  def applications_per_group_chart
    @applications_per_group_chart = LazyHighCharts::HighChart.new('pie') do |f|
      f.chart({ defaultSeriesType: 'pie', margin: [50, 200, 60, 170] })
      series = {
        type: 'pie',
        name: t('admissions_admin.applicants'),
        data: @applications_per_group
      }
      f.series(series)
      f.options[:title][:text] = t('admissions_admin.applications_by_group')
      f.legend(layout: 'vertical', style: { left: 'auto', bottom: 'auto', right: '50px', top: '100px' })
      f.plot_options(pie: {
        allowPointSelect: true,
        cursor: 'pointer',
        dataLabels: {
          enabled: true,
          color: 'black',
        }
      })
    end
  end

  # Count unique applicants and how many of those were actually admitted to Samfundet
  # This is done both for Samfundet as a whole and for each group
  def count_unique_applicants
    @unique_applicants_per_group = {}
    @accepted_applicants_per_group = {}
    @unique_applicants_total = []
    @admission.groups.map do |group|
      @unique_applicants_per_group[group] = Set[]
      @accepted_applicants_per_group[group] = 0

      group.jobs.where(admission_id: @admission.id).map do |job|
        job.applicants.map do |app|
          @unique_applicants_per_group[group].add app.id
          @unique_applicants_total.push app.id
          log_entries = LogEntry.where(admission_id: @admission.id, applicant_id: app.id)

          # An applicant can possibly be considered accepted if he/she/they has/have been logged,
          # and only any of the following acceptance strings below.
          unless log_entries.empty?
            last_log = log_entries.last

            @accepted_applicants_per_group[group] += 1 if application_is_accepted?(last_log.log)
          end
        end
      end
    end

    @unique_applicants_total = @unique_applicants_total.uniq.count
    @accepted_applicants_total = @accepted_applicants_per_group.values.reduce(:+)
  end
end

def application_is_accepted?(log)
  acceptance_strings = [

    'Ringt og tilbudt verv, takket ja',
    'Called and offered position, the applicant accepted'
  ]

  acceptance_strings.include?(log)
end