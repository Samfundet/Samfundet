# frozen_string_literal: true

class AdmissionInterviewMailer < ActionMailer::Base
  default from: 'no-reply@samfundet.no',
          reply_to: 'opptaksansvarlig@samfundet.no'

  def send_interview_email(applicant, subject, job, jobs, interview_time, interview_location)
    @applicant = applicant
    @job = job
    @jobs = jobs
    @interview_time = interview_time
    @interview_location = interview_location
    mail(to: applicant.lowercase_email, subject: subject, reply_to: job.contact_email)
  end
end
