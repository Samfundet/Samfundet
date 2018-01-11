# frozen_string_literal: true
class AdmissionsAdmin::CampusController < ApplicationController
  filter_access_to [:admin], require: :edit

  def admin
    @campuses = Campus.order(:name)
    @campus_count = Campus.number_of_applicants_current_admission
  end

  def new
    @campus = Campus.new
  end

  def create
    @campus = Campus.new(params[:campus])
    if @campus.save
      flash[:success] = t('save_success')
      redirect_to action: :admin
    else
      flash[:message] = t('save_error')
      render :new
    end
  end

  def edit
    @campus = Campus.find(params[:id])
  end

  def show
    @campus = Campus.find(params[:id])
  end

  def update
    @campus = Campus.find params[:id]
    if @campus.update_attributes(params[:campus])
      flash[:success] = t('update_success')
      redirect_to action: :admin
    else
      flash.now[:error] = t('update_error')
      render :edit
    end
  end

  def activate
    @campus = Campus.find params[:campus_id]
    @campus.update_attributes(active: true)
    redirect_to action: :admin
  end

  def deactivate
    @campus = Campus.find params[:campus_id]
    @campus.update_attributes(active: false)
    redirect_to action: :admin
  end
end
