# frozen_string_literal: true

class SultenNotificationMailer < ActionMailer::Base
  default from: 'booking-lyche@uka.no',
          reply_to: 'booking-lyche@uka.no'

  def send_reservation_email(reservation)
    @reservation = reservation
    mail(to: reservation.email, subject: 'Din reservasjon er registrert')
  end
end
