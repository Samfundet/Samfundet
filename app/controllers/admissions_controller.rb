# frozen_string_literal: true

class AdmissionsController < ApplicationController
  load_and_authorize_resource

  layout 'admissions'

  def index
    # First check if we can find any active admissions marked as primary
    @open_admissions = Admission.appliable.primary.includes(
      group_types: { groups: :jobs }
    )
    if @open_admissions.empty?
      # No active primary admissions found, now find non-primary
      @open_admissions = Admission.appliable.includes(
        group_types: { groups: :jobs }
      )
    end

    # TODO: figure out logic of upcoming primary/non-primary admissions
    @closed_admissions = Admission.no_longer_appliable
    @upcoming_admissions = Admission.upcoming
  end

  def show
    @admission = Admission.appliable.includes(
      group_types: { groups: :jobs }
    ).find(params[:id])
  end
end
