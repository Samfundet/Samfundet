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
    @unlogged_applicants_grouped = @admission.groups.map do |group|
      [group, group.unlogged_applicants_in_each_job(@admission)]
    end.to_h
    @unlogged_applicants = @admission.unlogged_applicants
    @all_applicants = @admission.all_applicants
  end

  def log_all_applicants
    admission = Admission.find(params[:admission_id])
    text = params[:log_entry][:log]
    if admission.log_all_unlogged_applicants(text, @current_user)
      flash[:success] = t('admissions_admin.all_applicants_logged')
    else
      flash[:error] = t('helpers.models.group.save_error')
    end

    redirect_to admissions_admin_admission_show_unlogged_applicants_path
  end

  def log_single_applicant
    admission = Admission.find(params[:admission_id])
    applicant = Applicant.find(params[:applicant_id])
    group = Group.find(params[:group_id])
    text = params[:log_entry][:log]

    if applicant.log_with_text(text, group, admission, @current_user)
      flash[:success] = t('admissions_admin.unique_applicant_logged_flash',
                          name: applicant.full_name,
                          entry: text)
    else
      flash[:error] = t('helpers.models.group.save_error')
    end

    redirect_to admissions_admin_admission_show_unlogged_applicants_path
  end
end
