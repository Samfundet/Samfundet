# frozen_string_literal: true

class GroupsController < ApplicationController
  load_and_authorize_resource

  has_control_panel_applet :admin_applet,
                           if: -> { can? :edit, Group }

  def admin_applet; end

  def admin
    @group_types = GroupType.all.sort
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(group_params)
    if @group.save
      flash[:success] = 'Gjengen er opprettet.'
      redirect_to admin_groups_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'new'
    end
  end

  def edit; end

  def update
    if @group.update_attributes(group_params)
      flash[:success] = 'Gjengen er oppdatert.'
      redirect_to admin_groups_path
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

private

  def group_params
    params.require(:group).permit(:name, :abbreviation, :page_id, :website, :group_type_id)
  end
end
