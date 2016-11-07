# -*- encoding : utf-8 -*-
class RolesController < ApplicationController
  filter_access_to [:pass], attribute_check: true
  before_action :find_by_id, only: [:show, :edit, :update]

  has_control_panel_applet :admin_applet,
                           if: -> { permitted_to?(:manage, Role) }

  has_control_panel_applet :pass_applet,
                           if: -> { current_user.roles.passable.present? }

  def index
    # Anyone permitted to edit roles is also allowed to manage members,
    # so checking for :manage_members is sufficient

    # The reason for using unscoped....sort_by here is that the
    # column name 'title' used for the sort is ambiguous. When
    # upgrading to Rails 4, this can be replaced with
    #
    #      default_scope { order(:title) }
    #
    # in the model.
    @roles = Role.unscoped.with_permissions_to(:manage_members).sort_by(&:title)
  end

  def show
  end

  def new
    @role = Role.new
  end

  def create
    @role = Role.new(role_params)
    if @role.save
      flash[:success] = t('roles.role_created')
      redirect_to role_url @role
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'new'
    end
  end

  def edit
  end

  def update
    if @role.update_attributes(role_params)
      flash[:success] = "Rollen er oppdatert."
      redirect_to role_url @role
    else
      flash[:error] = t('common.fields_missing_error')
      render action: 'edit'
    end
  end

  def admin_applet
  end

  def pass_applet
    @roles = current_user.roles.passable
  end

  def pass
    @members_role = MembersRole.find_by(member_id: @current_user.id, role_id: @role.id)
    @members_role.destroy
    @member = Member.find params[:member_id].to_i
    MembersRole.create!(
      member: @member,
      role: @role
    )
    flash[:success] = t("roles.pass_success", role: @role.title, member: @member.full_name)
    redirect_to members_control_panel_path
  end

  protected

  def find_by_id
    @role = Role.find_by_id(params[:id].to_i)

    raise ActiveRecord::RecordNotFound if @role.nil?
  end

  def role_params
    params.require(:role).permit(:title, :name, :description, :passable, :role_id, :group_id)
  end
end
