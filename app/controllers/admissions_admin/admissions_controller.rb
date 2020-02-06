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

  def edit; end

  def update
    if @admission.update_attributes(admission_params)
      flash[:success] = 'Opptaket er oppdatert.'
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

  protected

  def find_by_id
    @admission = Admission.find(params[:id])
  end

  def admission_params
    params.require(:admission).permit(:title, :shown_from, :shown_application_deadline, :actual_application_deadline, :user_priority_deadline, :admin_priority_deadline, :groups_with_separate_admission, :promo_video)
  end

  private
  
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