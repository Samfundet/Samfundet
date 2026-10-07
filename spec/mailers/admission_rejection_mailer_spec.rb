# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionRejectionMailer do
  it 'uses the supplied subject and personalizes the rejection text' do
    applicant = create(:applicant, firstname: 'Ola')
    mail = described_class.send_rejection_email(applicant, subject: 'Admission result', intro: 'Hello', content: 'Thank you for applying')
    expect(mail.to).to eq([applicant.email])
    expect(mail.reply_to).to eq(['opptaksansvarlig@samfundet.no'])
    expect(mail.subject).to eq('Admission result')
    expect(mail.body.decoded).to include('Hello Ola,', 'Thank you for applying')
  end
end
