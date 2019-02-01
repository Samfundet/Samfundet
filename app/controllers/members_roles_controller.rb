# frozen_string_literal: true

class MembersRolesController < ApplicationController
  load_and_authorize_resource
  before_action :before_create, only: :create

  def destroy
    @members_role.destroy
    flash[:success] = 'Medlemmet er slettet.'
    redirect_to role_path(@members_role.role)
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
