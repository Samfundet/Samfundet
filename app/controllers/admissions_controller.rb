# frozen_string_literal: true

class AdmissionsController < ApplicationController
  load_and_authorize_resource

  layout 'admissions'
  before_action :find_by_id, only: %i[edit update]

  def index
    @open_admissions = Admission.appliable.includes(
      group_types: { groups: :jobs }
    )
    @closed_admissions = Admission.no_longer_appliable
    @upcoming_admissions = Admission.upcoming
  end

  def new
    @admission = Admission.new
  end

  def create
    @admission = Admission.new(admission_params)
    if @admission.save
      flash[:success] = t('admissions.registration_success')
      redirect_to admissions_path
    else
      flash[:error] = t('admissions.registration_error')
      render :new
    end
  end

  def edit; end

  def update
    if @admission.update_attributes(admission_params)
      flash[:success] = 'Opptaket er oppdatert.'
      redirect_to admissions_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

  protected

  def find_by_id
    @admission = Admission.find(params[:id])
  end

  def admission_params
    params.require(:admission).permit(:title, :shown_from, :shown_application_deadline, :actual_application_deadline, :user_priority_deadline, :admin_priority_deadline, :groups_with_separate_admission, :promo_video)
  end
end
