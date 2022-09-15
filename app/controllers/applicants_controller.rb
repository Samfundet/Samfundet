# frozen_string_literal: true

class ApplicantsController < ApplicationController
  layout 'admissions'
  load_and_authorize_resource only: %i[steal_identity show edit update search]
  skip_authorization_check only: %i[new create forgot_password generate_forgot_password_email reset_password change_password]

  has_control_panel_applet :steal_identity_applet,
                           if: -> { can? :steal_identity, Applicant }

  def new
    @applicant = Applicant.new
  end

  def create
    params[:applicant][:email].downcase!
    @applicant = Applicant.new(applicant_params)

    if @applicant.save
      login_applicant @applicant

      if pending_application?
        save_pending_application(@applicant)
        redirect_to job_applications_path
      else
        redirect_to admissions_path
      end
    else
      flash[:error] = t('applicants.registration_error')
      render :new
    end
  end

  def show
    @applicant = Applicant.find(params[:id])
  end

  def edit; end

  def update
    password_should_change = !(params[:applicant][:password].blank? &&
                               params[:applicant][:password_confirmation].blank?)

    if password_should_change
      applicant_pwd_check = Applicant.authenticate(@applicant.email,
                                                   params[:applicant][:old_password])
      if applicant_pwd_check.nil? and not current_user.roles.include? Role.super_user
        flash[:error] = t('applicants.update_error')
        @applicant.errors.add :old_password, t('applicants.password_missmatch')
        render :edit
        return
      end
    end

    unless password_should_change
      %i[old_password password password_confirmation].each do |key|
        params[:applicant].delete(key)
      end
    end

    if @applicant.update_attributes(applicant_params)
      if @current_user.class == Applicant
        flash[:success] = t('applicants.update_success')
        redirect_to job_applications_path
      elsif current_user.roles.include? Role.super_user
        flash[:success] = 'Søkerinformasjon endret'
        redirect_to members_control_panel_path
      end
    else
      flash[:error] = t('applicants.update_error')
      render :edit
    end
  end

  def forgot_password; end

  def generate_forgot_password_email
    @applicant = Applicant.find_by(email: params[:email])
    if !@applicant
      flash[:error] = t('applicants.password_recovery.email_unknown')
    elsif !@applicant.can_recover_password?
      flash[:error] = t('applicants.password_recovery.limit_reached')
    elsif PasswordRecovery.create!(applicant_id: @applicant.id,
                                   recovery_hash: @applicant.create_recovery_hash)
      begin
        ForgotPasswordMailer.forgot_password_email(@applicant).deliver
        flash[:success] = t('applicants.password_recovery.success',
                            email: @applicant.email)
      rescue Net::SMTPError
        # This will be one of those "derp" moments.
        flash[:error] = t('applicants.password_recovery.error')
      end
    else
      flash[:error] = t('applicants.password_recovery.error')
    end
    redirect_to forgot_password_path
  end

  def prepare_form
    @hash = params[:hash]
    @email = params[:email]
  end

  def reset_password
    @applicant = Applicant.find_by(email: params[:email])
    if !@applicant || !@applicant.check_hash(params[:hash])
      flash[:error] = t('applicants.password_recovery.hash_error')
      @applicant = nil
    else
      prepare_form
    end
  end

  def change_password
    @applicant = Applicant.find(params[:id])
    new_data = params[:applicant]
    if @applicant.check_hash(params[:hash])
      if @applicant.update_attributes(password: new_data[:password],
                                      password_confirmation: new_data[:password_confirmation])
        PasswordRecovery.find_by(applicant_id: @applicant.id).destroy
        flash[:success] = t('applicants.password_recovery.change_success')

        redirect_to login_path
      else
        prepare_form
        flash[:error] = t('applicants.password_recovery.change_error')
        render :reset_password
      end
    else
      prepare_form
      flash[:error] = t('applicants.password_recovery.change_error')
      render :reset_password
    end
  end

  def steal_identity_applet; end

  def steal_identity
    applicant = Applicant.find(params[:applicant_id])
    if applicant.nil?
      redirect_to members_control_panel_path, notice: 'Fant ikke søker'
    else
      session[:member_id] = nil
      session[:applicant_id] = applicant.id
      redirect_to root_path
    end
  end

  def search
    @applicants = Applicant.where(
      "UPPER(firstname) || ' ' || UPPER(surname) LIKE UPPER(?)" \
      ' OR UPPER(email) LIKE UPPER(?) OR id = ?',
      "%#{params[:term].upcase}%",
      "%#{params[:term].upcase}%",
      params[:term].to_i
    )

    respond_to do |format|
      format.json do
        # Note the parentheses; they're necessary to achieve
        # the correct precedence for the do-block.
        render json: (@applicants.map do |applicant|
          { value: "#{applicant.id} - #{applicant.full_name}",
            label: "#{applicant.full_name} (#{applicant.email})" }
        end)
      end
    end
  end

private

  def login_applicant(applicant)
    session[:applicant_id] = applicant.id
    session[:member_id] = nil
    cookies[:signed_in] = 1

    flash[:success] = t('applicants.registration_success')

    invalidate_cached_current_user
  end

  def applicant_params
    params.require(:applicant).permit(:firstname, :surname, :phone, :campus_id, :email, :password, :password_confirmation, :interested_other_positions, :gdpr_checkbox)
  end

  include PendingApplications
end
