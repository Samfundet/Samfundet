# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Interview do
  it 'stores priority and applicant status as symbols while accepting blanks' do
    interview = described_class.new(priority: :wanted, applicant_status: :accepted)
    expect(interview.priority).to eq(:wanted)
    expect(interview.applicant_status).to eq(:accepted)
    interview.priority = nil
    interview.applicant_status = nil
    expect(interview.priority).to be_nil
    expect(interview.applicant_status).to be_nil
  end

  it 'rejects unknown priorities and statuses' do
    interview = build(:interview, priority: :unknown, applicant_status: :unknown)
    expect(interview).not_to be_valid
    expect(interview.errors[:priority]).to be_present
    expect(interview.errors[:applicant_status]).to be_present
  end

  %i[no en].each do |locale|
    it "returns translated choices for #{locale}" do
      interview = build(:interview, priority: :wanted, applicant_status: :accepted)
      I18n.with_locale(locale) do
        priorities = locale == :no ? Interview::PRIORITIES_NO : Interview::PRIORITIES_EN
        statuses = locale == :no ? Interview::APPLICANT_STATUS_NO : Interview::APPLICANT_STATUS_EN
        expect(interview.priorities).to eq(priorities)
        expect(interview.priority_string).to eq(priorities[:wanted])
        expect(interview.applicant_statuses).to eq(statuses)
        expect(interview.applicant_status_string).to eq(statuses[:accepted])
      end
    end
  end

  it 'resolves the group through its application and job' do
    interview = create(:interview)
    expect(interview.group).to eq(interview.job_application.job.group)
  end

  it 'allows setting status only after the deadline when priority is set' do
    interview = create(:interview)
    deadline = interview.job_application.job.admission.admin_priority_deadline
    travel_to(deadline - 1.second) { expect(interview.can_set_status?).to be(false) }
    travel_to(deadline + 1.second) { expect(interview.can_set_status?).to be_truthy }
    interview.priority = nil
    travel_to(deadline + 1.second) { expect(interview.can_set_status?).to be_falsey }
  end
end
