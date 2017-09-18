class SultenNotificationMailer < ActionMailer::Base
  default from: "no-reply@samfundet.no",
          reply_to: "lyche@uka.no"

  def send_reservation_email(reservation)
    @reservation = reservation
    mail(to: reservation.email, subject: "Din reservasjon er registrert")
  end
end
