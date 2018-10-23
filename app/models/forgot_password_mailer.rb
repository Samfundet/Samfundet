# frozen_string_literal: true

class ForgotPasswordMailer < ActionMailer::Base
  helper :applicants

  default from: 'no-reply@samfundet.no',
          reply_to: 'no-reply@samfundet.no'

  def forgot_password_email(applicant)
    @applicant = applicant
    mail(to: @applicant.email,
         subject: I18n.t('applicants.password_recovery.email_subject'))
  end
end
