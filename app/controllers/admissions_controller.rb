# frozen_string_literal: true

class AdmissionsController < ApplicationController
  load_and_authorize_resource

  layout 'admissions'

  def index
    @closed_admissions = Admission.no_longer_appliable
    @upcoming_admissions = Admission.upcoming
  end
end
