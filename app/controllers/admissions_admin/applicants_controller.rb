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

  def send_rejection_email
    AdmissionRejectionMailer.send_rejection_email("test").deliver
    redirect_to admissions_path
    puts "Button calls controller function"
  end
end
