# frozen_string_literal: true

class JobApplicationConfirmationMailer < ActionMailer::Base
  default from: 'no-reply@samfundet.no',
          reply_to: 'opptaksansvarlig@samfundet.no'

  def send_confirmation_email(applicant, job, subject)
    @applicant = applicant
    @job = job
    mail(to: applicant.lowercase_email, subject: subject, reply_to: job.contact_email)
  end
end
