# -*- encoding : utf-8 -*-

class ApplicantsController < ApplicationController
  layout "admissions"
  filter_access_to :steal_identity
  filter_access_to [:show, :edit, :update], attribute_check: true

  has_control_panel_applet :steal_identity_applet,
    if: -> { permitted_to? :steal_identity, :applicants }

  def new
    @applicant = Applicant.new
  end

  def create
    @applicant = Applicant.new(params[:applicant])

    if @applicant.save
      login_applicant @applicant

      if pending_application?
        save_pending_application(@applicant)
        redirect_to job_applications_path
      else
        redirect_to admissions_path
      end
    else
      flash[:error] = t("applicants.registration_error")
      render :new
    end
  end

  def show
    @applicant = Applicant.find(params[:id])
  end

  def edit
  end

  def update
    password_should_change = !(params[:applicant][:password].blank? &&
                               params[:applicant][:password_confirmation].blank?)

    if password_should_change
      applicant_pwd_check = Applicant.authenticate(@applicant.email,
                                                   params[:applicant][:old_password])
      if applicant_pwd_check.nil?
        flash[:error] = t("applicants.update_error")
        @applicant.errors.add :old_password, t("applicants.password_missmatch")
        render :edit
        return
      end
    end

    unless password_should_change
      [:old_password, :password, :password_confirmation].each do |key|
        params[:applicant].delete(key)
      end
    end

    if @applicant.update_attributes(params[:applicant])
      flash[:success] = t("applicants.update_success")
      redirect_to admissions_path
    else
      flash[:error] = t("applicants.update_error")
      render :edit
    end
  end

  def forgot_password
  end

  def generate_forgot_password_email
    @applicant = Applicant.find_by_email(params[:email])
    if !@applicant
      flash[:error] = t("applicants.password_recovery.email_unknown")
    elsif !@applicant.can_recover_password?
      flash[:error] = t("applicants.password_recovery.limit_reached")
    elsif PasswordRecovery.create!(applicant_id: @applicant.id,
                                   recovery_hash: @applicant.create_recovery_hash)
      begin
        ForgotPasswordMailer.forgot_password_email(@applicant).deliver
        flash[:success] = t("applicants.password_recovery.success",
                            email: @applicant.email)
      rescue
        # This will be one of those "derp" moments.
        flash[:error] = t("applicants.password_recovery.error")
      end
    else
      flash[:error] = t("applicants.password_recovery.error")
    end
    redirect_to forgot_password_path
  end

  def reset_password
    @applicant = Applicant.find_by_email(params[:email])
    if !@applicant || !@applicant.check_hash(params[:hash])
      flash[:error] = t("applicants.password_recovery.hash_error")
      @applicant = nil
    else
      @hash = params[:hash]
    end
  end

  def change_password
    @applicant = Applicant.find(params[:id])
    new_data = params[:applicant]
    if @applicant.check_hash(params[:hash])
      if @applicant.update_attributes(password: new_data[:password],
                                      password_confirmation: new_data[:password_confirmation])
        PasswordRecovery.destroy_all(applicant_id: @applicant.id)
        flash[:success] = t("applicants.password_recovery.change_success")

        redirect_to login_path
      else
        flash[:error] = t("applicants.password_recovery.change_error")
        render :reset_password
      end
    else
      flash[:error] = t("applicants.password_recovery.change_error")
      render :reset_password
    end
  end

  def steal_identity_applet
  end

  def steal_identity
    session[:member_id] = nil
    session[:applicant_id] = Applicant.find_by_email(params[:applicant_email].downcase).id
    redirect_to root_path
  end

  private

  def login_applicant(applicant)
    session[:applicant_id] = applicant.id
    session[:member_id] = nil

    flash[:success] = t("applicants.registration_success")

    invalidate_cached_current_user
  end

  include PendingApplications
end
