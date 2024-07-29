# frozen_string_literal: true

class VerifyEmailApplicantMailer < ActionMailer::Base
  helper :applicant_verification

  default from: %("Samfundet" <mg-web@samfundet.no>),
          reply_to: 'mg-web@samfundet.no'

  def send_applicant_email_verification(applicant, admission = nil)
    @new_verification_hash_value = applicant.create_email_verification_hash
    existing_verification_hash = EmailVerification.find_by(applicant_id: applicant.id)

    if !existing_verification_hash
      EmailVerification.create!(applicant_id: applicant.id,
                                    verification_hash: @new_verification_hash_value)
    else
      existing_verification_hash.verification_hash = @new_verification_hash_value
      existing_verification_hash.count += 1
      existing_verification_hash.save!
    end

    @applicant = applicant
    @admission = admission
    mail(to: applicant.email, subject: t((@admission.present? && @admission.title.downcase.include?('isfit')) ? 'applicants.email_verification.email_subject_isfit' : 'applicants.email_verification.email_subject'))
  end
end
