# frozen_string_literal: true

class MemberSessionsController < UserSessionsController
  skip_authorization_check

  def new
    @redirect_to = params[:redirect_to]
    @member_login_id = params[:member_login_id]
  end

  def create
    member = Member.authenticate(params[:member_login_id], params[:member_password])

    if member.nil?
      flash.now[:error] = t('sessions.login_error')

      @member_login_id = params[:member_login_id]
      @redirect_to = params[:redirect_to]
      render :new
    else
      flash.now[:error] = 'Member controller login error'
      login_member member
      redirect_after_login root_path
    end
  end

private

  def login_member(member)
    session[:applicant_id] = nil
    session[:member_id] = member.id
    cookies[:signed_in] = 1
    flash[:success] = t('sessions.login_success', name: CGI.escapeHTML(member.full_name))
  end
end
