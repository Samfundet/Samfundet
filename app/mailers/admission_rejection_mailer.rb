# frozen_string_literal: true

class AdmissionRejectionMailer < ActionMailer::Base
  default from: 'no-reply@samfundet.no',
          reply_to: 'opptaksansvarlig@samfundet.no'

  def send_rejection_email(applicant, template)
    @applicant = applicant
    @template = template
    mail(to: applicant.email, subject: @template[:subject])
  end

  def send_test_email(template)
    @template = template
    mail(
        from: template[:sender],
        reply_to: template[:reply_to],
        to: template[:recipient],
        subject: template[:subject],
    )
  end

end
