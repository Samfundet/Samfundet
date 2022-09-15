# frozen_string_literal: true

class AdmissionsAdmin::ApplicantsController < AdmissionsAdmin::BaseController
  authorize_resource

  def show_interested_other_positions
    @admission = Admission.find(params[:admission_id])
    @applicants = Applicant.interested_other_positions(@admission)
  end

  def show_applicants_missing_interviews
    @admission = Admission.find(params[:admission_id])
    @applicants = Applicant.less_than_three_set_interviews(@admission)
  end

  def show_unflagged_applicants
    @admission = Admission.find(params[:admission_id])
    @applicants = Applicant.unflagged_applicants(@admission)
  end

  def edit_applicant
    @applicant = Applicant.find_by_id(params[:applicant_id])
  end
end
