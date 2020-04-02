# frozen_string_literal: true

# == Schema Information
#
# Table name: admissions
#
#  id                             :bigint           not null, primary key
#  title                          :string
#  shown_application_deadline     :datetime
#  user_priority_deadline         :datetime
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  shown_from                     :datetime
#  admin_priority_deadline        :datetime
#  actual_application_deadline    :datetime
#  promo_video                    :string           default("https://www.youtube.com/embed/T8MjwROd0dc")
#  groups_with_separate_admission :text
#
require 'rails_helper'

describe Admission, '.open_admissions?' do
  it 'returns true if open admissions' do
    create(:admission)
    expect(Admission.open_admissions?).to eq true
  end

  it 'returns false if no open admissions' do
    create(:admission, shown_from: 2.days.from_now)
    create(:admission, :past)
    expect(Admission.open_admissions?).to eq false
  end
end

describe Admission, '.active_admissions?' do
  # Defined as at admin priority deadline not passed
  it 'returns true if active admissions' do
    create(:admission)
    expect(Admission.active_admissions?).to eq true
  end

  it 'returns false if no active admissions' do
    create(:admission, :past)
    expect(Admission.active_admissions?).to eq false
  end
end

describe Admission, '#appliable?' do
  # (actual_application_deadline > Time.current) && (shown_from < Time.current)
  it 'returns true if actual deadline in the future and shown from in the past' do
    admission = create(:admission)
    expect(admission.appliable?).to eq true
  end

  it 'should be true just after the shown application deadline' do
    admission = create(:admission,
                       shown_application_deadline: 1.minute.ago,
                       actual_application_deadline: 1.hour.from_now)
    expect(admission.appliable?).to eq true
  end

  it 'should be false some time after the shown application deadline' do
    admission = create(:admission,
                       shown_application_deadline: 1.hour.ago,
                       actual_application_deadline: 1.minute.ago)
    expect(admission.appliable?).to eq false
  end
end
