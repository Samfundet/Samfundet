# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admission do
  it 'rejects deadlines that are before their preceding milestone' do
    { shown_application_deadline: :shown_from, actual_application_deadline: :shown_application_deadline, user_priority_deadline: :actual_application_deadline, admin_priority_deadline: :user_priority_deadline }.each do |field, previous|
      admission = build(:admission)
      admission.public_send("#{field}=", admission.public_send(previous) - 1.minute)
      expect(admission).not_to be_valid
      expect(admission.errors[field]).to be_present
    end
  end
  it 'enforces application and prioritization deadlines at exact boundaries' do
    admission = create(:admission)
    %i[actual_application_deadline user_priority_deadline shown_from].each do |field|
      admission.public_send("#{field}=", admission.public_send(field).change(usec: 0))
    end
    travel_to(admission.actual_application_deadline) { expect(admission.appliable?).to be(false) }
    travel_to(admission.user_priority_deadline) { expect(admission.prioritize?).to be(false) }
    travel_to(admission.shown_from) { expect(admission.appliable?).to be(false) }
  end
  it 'identifies old admissions and ISFIT admissions' do
    admission = build(:admission, :past, title: 'ISFiT admission', admin_priority_deadline: 40.days.ago)
    expect(admission.isfit?).to be(true)
    expect(admission.very_old?).to be(true)
    admission.title = 'Ordinary admission'
    expect(admission.isfit?).to be(false)
  end
  it 'provides interview dates after the actual deadline through the priority deadline' do
    admission = build(:admission)
    expect(admission.interview_dates).to eq(((admission.actual_application_deadline.to_date + 1)..admission.user_priority_deadline.to_date).to_a)
    expect(admission.to_s).to include(admission.title)
    admission.id = 7
    expect(admission.to_param).to eq('7-opptak')
    admission.title = nil
    expect(admission.to_param).to eq('7')
  end
  it 'groups customized jobs without duplicate labels' do
    admission = create(:admission)
    first = create(:job, admission: admission, custom_group_type: 'A', custom_group: 'First')
    create(:job, admission: admission, custom_group_type: 'A', custom_group: 'First')
    create(:job, admission: admission, custom_group_type: '', custom_group: '')
    expect(admission.custom_group_types).to eq(['A', ''])
    expect(admission.custom_group('A')).to eq(['First'])
    expect(admission.jobs_in_custom_group('First', 'A')).to include(first)
  end
end
