# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SultenNotificationMailer do
  it 'includes booking details even when optional allergies are absent' do
    reservation = create(:sulten_reservation, allergies: nil)
    mail = described_class.send_reservation_email(reservation)
    expect(mail.to).to eq([reservation.email])
    expect(mail.from).to eq(['lyche@samfundet.no'])
    expect(mail.subject).to eq('Din reservasjon er registrert')
    expect(mail.body.decoded).to include(reservation.first_name, reservation.telephone, reservation.reservation_type.name)
  end
end
