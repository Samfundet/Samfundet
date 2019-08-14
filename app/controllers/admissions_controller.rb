# frozen_string_literal: true

class AdmissionsController < ApplicationController
  load_and_authorize_resource

  layout 'admissions'

  def index
    cookies[:signed_in] = 1
    @open_admissions = Admission.appliable.includes(
      group_types: { groups: :jobs }
    )
    @closed_admissions = Admission.no_longer_appliable
    @upcoming_admissions = Admission.upcoming
  end
end
