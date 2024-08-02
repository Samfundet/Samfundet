# frozen_string_literal: true

module ApplicantVerificationHelper
  def email_verification_link(args = {})
    email = args[:email]
    applicant_id = args[:applicant_id]
    verification_hash = args[:verification_hash]
    admission_id = args[:admission_id]

    if email.nil? || applicant_id.nil? || verification_hash.nil?
      raise 'Email, appicantId or verification_hash not supplied.'
    end

    verify_email_url(email: email, applicant: applicant_id, hash: verification_hash, admission: admission_id)
  end
end
