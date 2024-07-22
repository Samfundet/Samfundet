# frozen_string_literal: true

class AdmissionsController < ApplicationController
  load_and_authorize_resource

  layout 'admissions'

  def index
    @open_admissions = Admission.appliable.includes(
      group_types: { groups: :jobs }
    )
    @closed_admissions = Admission.no_longer_appliable
    @upcoming_admissions = Admission.upcoming
  end

  def show
    @admission = Admission.appliable.includes(
      group_types: { groups: :jobs }
    ).find(params[:id])
  end
end
