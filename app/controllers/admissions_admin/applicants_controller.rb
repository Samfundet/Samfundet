class AdmissionsAdmin::ApplicantsController < ApplicationController
  def show_interested_other_positions
    @admission = Admission.find(params[:admission_id])
    if @admission.admin_priority_deadline > Time.current
      return @applicants = []
    else
      @applicants = Applicant.interested_other_positions(@admission)
    end
  end
end
