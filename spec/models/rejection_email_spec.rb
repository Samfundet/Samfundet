# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RejectionEmail do
  it 'requires an admission, applicant and sent time' do
    record = RejectionEmail.new
    expect(record).not_to be_valid
    %i[admission applicant sent_at].each { |field| expect(record.errors[field]).to be_present }
    record.assign_attributes(admission: build(:admission), applicant: build(:applicant), sent_at: Time.current)
    expect(record).to be_valid
  end
end
