# frozen_string_literal: true

class AdmissionsAdmin::JobsController < AdmissionsAdmin::BaseController
  load_and_authorize_resource
  layout 'admissions'
  before_action :before_new_and_create_and_search, only: %i[new create search]

  def new; end

  def create
    @job.update(job_params)
    if @job.save
      flash[:success] = t('jobs.job_created')
      redirect_to admissions_admin_admission_group_path(@admission, @group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :new
    end
  end

  def assign_interview_times
    @job = Job.find(params[:job_id])

    # Check if the set interviews have linked interview_time_slots
    # If they don't, link them together with an existing one, that matches the interview time.
    @applications_with_set_interviews = @job.job_applications_with_interviews
    @applications_with_set_interviews.each do |j|
      if j.interview.interview_time_slot_id.nil?
        @interview_time_slots = InterviewTimeSlot.where(job: @job).order('start_time')
        @interview_time_slots.each do |i|
          if i.location == j.interview.location || j.interview.location == ''
            possible_times = i.possible_times
            if possible_times.include? j.interview.time.to_s
              j.interview.interview_time_slot_id = i.id
              j.interview.location = i.location
              j.interview.save!
              break
            end
          end
        end
      end
    end

    @job_applications = @job.job_applications_without_interviews.sort_by { |ja| ja.created_at }

    @set_interview_times = @job.get_set_interview_times
    $admission_id = @job.admission.id

    @job_applications.each do |j|
      @applicant = j.applicant
      applicant_unavailable_times = @applicant.get_impossible_interview_times
      interview = j.find_or_create_interview

      @interview_time_slots = InterviewTimeSlot.where(job: @job).sort_by { |it| [it.start_time, -(it.number_of_interviews)] }
      @interview_time_slots.each do |i|
        possible_times = i.possible_times(applicant_unavailable_times)

        if possible_times.length > 0
          interview.time = possible_times[0]
          interview.location = i.location
          interview.interview_time_slot_id = i.id
          interview.save!

          # Only send email if interview time has been set.
          email_subject = "Intervju hos #{@job.group.name}"
          @jobs = []

          # Check if an interview can be linked with multiple jobs
          if @job.linkable_interviews
            @jobs = @applicant.link_interviews(interview, @job.group)
          end

          # If linkable interviews are possible, jobs list will be > 0
          # A different email containing all of the job mails will be sent instead.
          AdmissionInterviewMailer.send_interview_email(@applicant, email_subject, @job, @jobs, interview.time, interview.location).deliver

          @set_interview_times.push(possible_times[0])
          break
        end
      end
    end

    redirect_back(fallback_location: root_path)
  end

  def show
    @job = Job.find(params[:id])
    @group = Group.find(params[:group_id])
    @admission = Admission.find(params[:admission_id])

    @accepted_applications = @job.accepted_applications
    @unprocessed_applications = @job.unprocessed_applications
    @contacted_applications = @job.contacted_applications
    @auto_rejected_applications = @job.automatically_rejected_applications
    @withdrawn_applications = @job.withdrawn_applications
  end

  def show_unprocessed
    @job = Job.find(params[:job_id])
    @groupings = [@job.unprocessed_applications]
    @group = Group.find(params[:group_id])
    @admission = Admission.find(params[:admission_id])
    render partial: 'jobs_show'
  end

  def search
    @query = "%#{params[:q]}%"
    @jobs = @group.jobs.where('title_no LIKE ? OR teaser_no LIKE ? OR description_no LIKE ? OR title_en LIKE ? OR teaser_en LIKE ? OR description_en LIKE ?', @query, @query, @query, @query, @query, @query).limit(10)
    render layout: false
  end

  def edit; end

  def update
    if @job.update_attributes(job_params)
      flash[:success] = t('jobs.job_updated')
      redirect_to admissions_admin_admission_group_path(@job.admission, @job.group)
    else
      flash[:error] = t('common.fields_missing_error')
      render :edit
    end
  end

  def destroy
    @job.destroy
    flash[:success] = t('jobs.job_deleted')
    redirect_to admissions_admin_admission_group_path(@job.admission, @job.group)
  end

private

  def job_params
    params.require(:job).permit(
      :title_no,
      :title_en,
      :teaser_no,
      :teaser_en,
      :description_no,
      :description_en,
      :default_motivation_text_no,
      :default_motivation_text_en,
      :is_officer,
      :tag_titles,
      :contact_email,
      :contact_phone,
      :interview_interval,
      :linkable_interviews
    )
  end

  def before_new_and_create_and_search
    @admission = Admission.find(params[:admission_id])
    @group = Group.find(params[:group_id])
    @job = Job.new(admission: @admission, group: @group)
  end
end
