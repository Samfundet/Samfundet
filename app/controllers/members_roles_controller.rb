# frozen_string_literal: true

class MembersRolesController < ApplicationController
  # Do not load resource here. We are customly loading the resource so Can^3s condition on the resource (role) can be applied
  authorize_resource
  before_action :before_create, only: :create

  def destroy
    @members_role = MembersRole.find params[:id]
    @members_role.destroy
    flash[:success] = 'Medlemmet er slettet fra rollen.'
    redirect_back(fallback_location: root_path)
  end

  def create
    if @members_role.role.members.include? @members_role.member
      flash[:error] = 'Medlemmet har allerede denne rollen.'
    else
      @members_role.save!
      flash[:success] = 'Medlemmet er lagt til.'
    end
    redirect_to role_path(@members_role.role)
  end

private

  def before_create
    @members_role = MembersRole.new(
      member: Member.find(params[:member_id].to_i),
      role: Role.find(params[:role_id].to_i)
    )
  end
end
