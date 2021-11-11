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
    @open_admissions = Admission.appliable.includes(
      group_types: { groups: :jobs }
    )

    redirect_to admissions_admin_admission_group_path(@admission, @my_groups.first) if @my_groups.length == 1
  end

  # Admission overview for admission leader
  def overview
    @groups = Group.all

    @applications = []
    @processed = []
    @accepted = []
    @auto_reject = []

    @groups.each do |g|
      jobs = g.jobs_in_admission(@admission)
      tot_procs = tot_rej = []
      tot_acct = tot_apps = []
      jobs.each do |j|
        tot_apps += j.active_applications
        tot_procs += j.processed_applications
        tot_acct += j.accepted_applications
        tot_rej += j.automatically_rejected_applications
      end
      @applications.append(tot_apps)
      @processed.append(tot_procs)
      @auto_reject.append(tot_rej)
      @accepted.append(tot_acct)
    end

    # TODO find conflicts when two groups accept same person
    # @conflicts = {}
    # @groups.each_with_index do |g, i|
    # end

    @total_applications = @applications.flatten.count
    @total_processed = @processed.flatten.count
    @total_unique_applicants = @applications.flatten.map { |x| x.applicant }.uniq.count
    @total_unique_accepted = @accepted.flatten.map { |x| x.applicant }.uniq.count
    auto_rejected = automatically_rejected_applicants
    @total_unique_rejected = auto_rejected.count
    @admission_complete = @total_processed == @total_applications

    rejection_emails = @admission.rejection_emails
    @sent_rejection_emails = rejection_emails.count

    # Calculates if any applicants that should received email
    # has not received one yet. Usually sends should only be done once,
    # but this is a safety mechanism in case something goes wrong.
    if @sent_rejection_emails > 0
      @missing = auto_rejected.map { |r| r.id } - rejection_emails.map { |r| r.applicant_id }
      @missing = @missing.uniq
    end
  end

  # Prepare automatic rejection email
  def prepare_rejection_email
  end

  # Review automatic rejection email
  def review_rejection_email
    # For email preview/send
    @template = {
        subject: params[:subject],
        intro: params[:introduction],
        content: params[:content]
    }

    # Find total number of applicants
    all_applications = []
    Group.all.each do |g|
      jobs = g.jobs_in_admission(@admission)
      jobs.each do |j|
        all_applications += j.active_applications
      end
    end

    # Recipients are all applicants with a rejected application except those who were accepted at least once
    @recipients = calculate_rejection_recipients
    @total_unique_applicants = all_applications.flatten.map { |a| a.applicant }.uniq.count
    @sent_rejection_emails = @admission.rejection_emails
    @already_rejected_applicants = @sent_rejection_emails.map { |r| r.applicant_id }
  end

  # Sends rejection email to recipients
  def send_rejection_email
    @recipients = calculate_rejection_recipients
    @template = {
        subject: params[:subject],
        intro: params[:intro],
        content: params[:content]
    }
  end

  # Async response for send rejection email
  def send_rejection_email_result
    # Get recipients
    @recipients = calculate_rejection_recipients

    @template = {
        subject: params[:subject],
        intro: params[:intro],
        content: params[:content]
    }

    @success = []
    @failure = []
    @errors = []

    @recipients.each do |r|
      # Rejection email database save
      rej = RejectionEmail.new(
          admission: @admission,
          applicant: r,
          sent_at: Time.now
      )
      # Safely send emails
      begin
        rej.save!
        AdmissionRejectionMailer.send_rejection_email(r, @template).deliver
        @success.append(r)
      rescue Error => e
        rej.delete!
        @failure.append(r)
        @errors.append(e)
      end
    end

    render partial: 'send_rejection_email_result'
  end

  def rejection_email_list
    @rejection_emails = @admission.rejection_emails.joins(:applicant).order('surname asc')
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

  def list
    @open_admissions = Admission.appliable.includes(
        group_types: { groups: :jobs }
    )
    @closed_admissions = Admission.no_longer_appliable
    @upcoming_admissions = Admission.upcoming
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

    count_unique_applicants_in_groups
    calculate_applicants_admitted_ratio
    total_accepted_applicants

    sort_admissions
    admin_applet


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
    applications_per_hour_chart
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

  # Calculate who should receive rejection email
  # Excludes those who already received an email
  def calculate_rejection_recipients
    rejected = automatically_rejected_applicants
    already_sent = @admission.rejection_emails.map { |r| r.applicant_id }
    # Select all not already sent
    rejected.select { |r| not already_sent.include?(r.id) }
  end

  # Calculates who are marked to receive automatic rejection email
  def automatically_rejected_applicants
    rejected_somewhere = []
    contacted_somewhere = []

    Group.all.each do |g|
      jobs = g.jobs_in_admission(@admission)
      jobs.each do |j|
        rejected_somewhere += j.automatically_rejected_applications
        contacted_somewhere += j.contacted_applications
      end
    end

    # Convert to unique applicants
    rejected_somewhere = rejected_somewhere.flatten.map { |x| x.applicant }.uniq
    contacted_somewhere = contacted_somewhere.flatten.map { |x| x.applicant }.uniq

    # Return those rejected somewhere if not accepted anywhere
    rejected_somewhere - contacted_somewhere
  end


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

  def applications_per_hour_chart
    hours = (0..23).to_a.map { |x| format('%02d', x) }
    applications_per_hour = hours.map do |hour|
      @admission.job_applications.where('extract(hour from job_applications.created_at) = ?', hour).count
    end

    @applications_per_hour = (hours).zip(applications_per_hour)

    @applications_per_hour_chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.series(data: @applications_per_hour, type: 'spline', name: t('admissions_admin.applications'))
      f.yAxis(title: { text: t('admissions_admin.applications') }, allowDecimals: false)
      f.xAxis(title: { text: t('admissions_admin.hour') }, categories: (hours).map(&:to_s))
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

  def total_accepted_applicants
    total_applicants = @admission.job_applications.map(&:applicant).uniq
    @total_accepted_applicants = total_applicants.select do |a|
      last_log_entry = LogEntry.where(admission: @admission, applicant: a).last
      next if last_log_entry.nil?
      application_is_accepted?(last_log_entry)
    end
  end

  def calculate_applicants_admitted_ratio
    @total_applicants = @admission.job_applications.map(&:applicant).uniq
    @ratio = total_accepted_applicants.count.to_f / @total_applicants.count * 100
  end

  def calculate_group_applicants_admitted_ratio(accepted_total_hash)
    accepted = accepted_total_hash[:accepted]
    total = accepted_total_hash[:total]

    if total.empty?
      accepted_total_hash[:ratio] = 0
    else
      accepted_total_hash[:ratio] = accepted.count.to_f / total.count * 100
    end
  end

  # Count unique applicants and how many of those were actually admitted to Samfundet
  # This is done both for Samfundet as a whole and for each group
  def count_unique_applicants_in_groups
    @applicants = {}

    @admission.groups.map do |group|
      @applicants[group] = { total: Set[], accepted: Set[] }

      applicants = group.job_applications_in_admission(@admission).map(&:applicant).uniq
      applicants.each do |app|
        @applicants[group][:total].add app.id

        log_entries = LogEntry.where(admission_id: @admission.id, applicant_id: app.id, group_id: group.id)

        unless log_entries.empty?
          last_log = log_entries.last
          if application_is_accepted?(last_log)
            @applicants[group][:accepted].add app.id
          end
        end
      end

      calculate_group_applicants_admitted_ratio(@applicants[group])
    end
  end
end

def application_is_accepted?(log)
  log.is_acceptance_log_entry?
end

def sort_admissions
  current_index = 0
  sorted_admissions = Admission.all
  sorted_admissions.sort_by { |shown_from| }.each_with_index do |admission, index|
    if @admission === sorted_admissions[index]
      current_index = index
      break
    end
  end
  @previous_admission = sorted_admissions[current_index + 1] if current_index <= sorted_admissions.length - 1
  @next_admission = sorted_admissions[current_index - 1] if current_index > 0
end
