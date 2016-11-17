# frozen_string_literal: true
class AdmissionsAdmin::ApplicantsController < ApplicationController
  def show_interested_other_positions
    @admission = Admission.find(params[:admission_id])
    @applicants = Applicant.interested_other_positions(@admission)
  end
end
