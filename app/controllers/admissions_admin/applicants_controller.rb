# frozen_string_literal: true

class AdmissionsAdmin::ApplicantsController < AdmissionsAdmin::BaseController
  authorize_resource

  def show_interested_other_positions
    @admission = Admission.find(params[:admission_id])
    @applicants = Applicant.interested_other_positions(@admission)
  end

  def show_unflagged_applicants
    @admission = Admission.find(params[:admission_id])
    @applicants = Applicant.unflagged_applicants(@admission)
  end

  def show_unlogged_applicants
    @admission = Admission.find(params[:admission_id])
    @log_entries = LogEntry.possible_log_entries
    @applicants = @admission.unlogged_applicants
    @group_jobs = @applicants
                    .flat_map(&:job_applications)
                    .select { |job_a| job_a.job.admission == @admission }
                    .group_by { |job_a| job_a.job.group }
                    .sort_by { |k, _| k.name }

    respond_to do |format|
      format.html
      format.csv
    end
  end

  def log_all_applicants
    admission = Admission.find(params[:admission_id])
    group_jobs = get_groups_and_unlogged_applicants(admission)

    group_jobs.each do |group, job_applicants|
      job_applicants.each do |j|
        puts j.applicant.full_name
        add_entry_to_applicant(admission, j.applicant, group, params[:log_entry][:log])
      end
    end

    flash[:success] = t('admissions_admin.all_applicants_logged')
    redirect_to admissions_admin_admission_show_unlogged_applicants_path
  end

  def log_single_applicant
    admission = Admission.where(id: params[:admission_id]).first
    applicant = Applicant.where(id: params[:applicant_id]).first
    group = Group.where(id: params[:group_id]).first
    log_entry_text = params[:log_entry][:log]

    add_entry_to_applicant(admission, applicant, group, log_entry_text)

    flash[:success] = t('admissions_admin.unique_applicant_logged_flash',
                        name: applicant.full_name,
                        entry: log_entry_text)

    redirect_to admissions_admin_admission_show_unlogged_applicants_path
  end

private

  def add_entry_to_applicant(admission, applicant, group, entry_text)
    log_entry = LogEntry.create!(
      admission: admission,
      applicant: applicant,
      group: group,
      member: @current_user,
      log: entry_text,
    )

    applicant.log_entries << log_entry
    applicant.save
  end
end
