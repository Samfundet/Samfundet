# frozen_string_literal: true

class AdmissionRejectionMailer < ActionMailer::Base
  default from: 'no-reply@samfundet.no',
          reply_to: 'test@samfundet.no'

  def send_email_to_rejected_applicants(list_of_applicants)
    @applicants = list_of_applicants
    @applicants.each { |applicant|
      send_rejection_email(applicant)
    }
  end

  def send_rejection_email(applicant)
    puts "Controller calls mailer"
    @applicant = applicant
    /mail(to: applicant.email, subject: 'Din søknad på samfundet')/
    mail(to: "konstahm@gmail.com", subject: 'Din søknad på samfundet')
  end
end
