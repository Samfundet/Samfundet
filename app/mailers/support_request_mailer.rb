class SupportRequestMailer < ActionMailer::Base
  require 'mail'
  def send_request(form_data)
    address = Mail::Address.new form_data.email
    address.display_name = form_data.name.dup
    @form_data = form_data
    mail(to: form_data.recipient, reply_to: address.format, subject: form_data.subject, from: 'noreply@samfundet.no')
  end
end
