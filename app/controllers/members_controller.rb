# -*- encoding : utf-8 -*-
class MembersController < ApplicationController
  filter_access_to [:search, :control_panel, :steal_identity]

  has_control_panel_applet :steal_identity_applet,
                           if: -> { permitted_to? :steal_identity, :members }

  has_control_panel_applet :access_applet,
                           if: -> { true }

  def search
    @members = Member.where(
      "UPPER(fornavn) || ' ' || UPPER(etternavn) LIKE UPPER(?)" \
      " OR UPPER(mail) LIKE UPPER(?) OR medlem_id = ?",
      "%#{params[:term].upcase}%",
      "%#{params[:term].upcase}%",
      params[:term].to_i
    )

    respond_to do |format|
      format.json do
        # Note the parentheses; they're necessary to achieve
        # the correct precedence for the do-block.
        render json: (@members.map do |member|
          { value: "#{member.id} - #{member.full_name}",
            label: "#{member.full_name} (#{member.mail})" }
        end)
      end
    end
  end

  def control_panel
    @applets = ControlPanel.applets(request).select &:relevant?
  end

  def steal_identity_applet
  end

  def steal_identity
    session[:member_id] = Member.find(params[:member_id]).id
    session[:applicant_id] = nil
    redirect_to root_path
  end

  def access_applet
  end
end
