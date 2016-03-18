require 'rails_helper'

describe Admission, '.has_open_admissions?' do
	it 'returns true if open admissions' do
		admission = create(:admission)
		expect(Admission.has_open_admissions?).to eq true
	end

	it 'returns false if no open admissions' do
		admission = create(:admission, shown_from: 2.days.from_now)
		admission2 = create(:admission, actual_application_deadline: 1.days.ago)
		expect(Admission.has_open_admissions?).to eq false
	end
end

describe Admission, '.has_active_admissions?' do
	# Defined as at admin priority deadline not passed
	it 'returns true if active admissions' do
		admission = create(:admission)
		expect(Admission.has_active_admissions?).to eq true
	end

	it 'returns false if no active admissions' do
		admission = create(:admission, admin_priority_deadline: 1.days.ago, user_priority_deadline: 1.days.ago-1.hour)
		expect(Admission.has_active_admissions?).to eq false
	end
end
