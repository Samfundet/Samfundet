# -*- encoding : utf-8 -*-
class AdmissionsController < ApplicationController
  layout 'admissions'
  before_filter :find_by_id, only: [:edit, :update]
  filter_access_to [:new, :create, :edit, :update]

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :show, :admissions_admin_admissions }

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
    @admission = Admission.new(params[:admission])
    if @admission.save
      flash[:success] = t("admissions.registration_success")
      redirect_to admissions_path
    else
      flash[:error] = t("admissions.registration_error")
      render :new
    end
  end

  def edit
  end

  def update
    if @admission.update_attributes(params[:admission])
      flash[:success] = "Opptaket er oppdatert."
      redirect_to admissions_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

  def admin_applet
    @admissions = Admission.current
  end

  protected

  def find_by_id
    @admission = Admission.find(params[:id])
  end
end
