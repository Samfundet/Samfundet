# frozen_string_literal: true

class AdmissionsController < ApplicationController
  load_and_authorize_resource except: :show_public
  skip_authorization_check only: %i[show_public]

  layout 'admissions'

  def index
    @open_admissions = Admission.appliable.primary.includes(
      group_types: { groups: :jobs }
    )
    @upcoming_admissions = Admission.upcoming.primary
    @closed_admissions = Admission.no_longer_appliable.primary
  end

  def show_public
    @admission = Admission.appliable.includes(
      group_types: { groups: :jobs }
    ).find(params[:id])
  end
end
