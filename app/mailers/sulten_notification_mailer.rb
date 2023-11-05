# frozen_string_literal: true

class SultenNotificationMailer < ActionMailer::Base
  default from: 'lyche@samfundet.no',
          reply_to: 'lyche@samfundet.no'

  def send_reservation_email(reservation)
    @reservation = reservation
    mail(to: reservation.email, subject: 'Din reservasjon er registrert')
  end
end
