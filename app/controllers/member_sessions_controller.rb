# -*- encoding : utf-8 -*-
class MemberSessionsController < UserSessionsController

  def new
    @redirect_to = params[:redirect_to]
    @member_login_id = params[:member_login_id]
  end

  def create
    member = Member.authenticate(params[:member_login_id], params[:member_password])

    unless member.nil?
      login_member member
      redirect_after_login root_path
    else
      flash.now[:error] = t("sessions.login_error")

      @member_login_id = params[:member_login_id]
      @redirect_to = params[:redirect_to]
      render :new
    end
  end

  private

  def login_member(member)
    session[:applicant_id] = nil
    session[:member_id] = member.id
    flash[:success] = t("sessions.login_success", name: CGI.escapeHTML(member.full_name))
  end
end
