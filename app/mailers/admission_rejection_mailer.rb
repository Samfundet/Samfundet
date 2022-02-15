# frozen_string_literal: true

class AdmissionRejectionMailer < ActionMailer::Base
  default from: 'opptaksansvarlig@samfundet.no',
          reply_to: 'opptaksansvarlig@samfundet.no'

  def send_rejection_email(applicant, template)
    @applicant = applicant
    @template = template
    mail(to: applicant.email, subject: @template[:subject])
  end
end
