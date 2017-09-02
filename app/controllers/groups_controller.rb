# -*- encoding : utf-8 -*-
class GroupsController < ApplicationController
  filter_access_to [:new, :create]
  filter_access_to [:edit, :update], attribute_check: true
  filter_access_to :admin, require: :edit

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to? :edit, :groups }

  def admin_applet
  end

  def admin
    @group_types = GroupType.all.sort
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    if @group.save
      flash[:success] = "Gjengen er opprettet."
      redirect_to admin_groups_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @group.update_attributes(params[:group])
      flash[:success] = "Gjengen er oppdatert."
      redirect_to admin_groups_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end
end
