require 'rails_helper'

describe Admission, '.has_open_admissions?' do
	it 'returns true if open admissions' do
		admission = create(:admission)
		expect(Admission.has_open_admissions?).to eq true
	end

	it 'returns false if no open admissions' do
		admission = create(:admission, shown_from: 2.days.from_now)
		admission2 = create(:admission, :past)
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
		admission = create(:admission, :past)
		expect(Admission.has_active_admissions?).to eq false
	end
end

describe Admission, '#has_jobs?' do
	it 'returns true if any jobs are found' do
		admission = create(:admission)
		jobs = create_list(:job, 5, admission: admission)
		expect(admission.has_jobs?).to eq true
	end

	it 'returns false if no jobs are found' do
		admission = create(:admission)
		expect(admission.has_jobs?).to eq false
	end
end

describe Admission, '#appliable?' do
	#(actual_application_deadline > Time.current) && (shown_from < Time.current)
	it "returns true if actual deadline in the future and shown from in the past" do
		admission = create(:admission)
		expect(admission.appliable?).to eq true
	end

	it "should be true just after the shown application deadline" do
		admission = create(:admission,
			shown_application_deadline: 1.minute.ago,
			actual_application_deadline: 1.hour.from_now)
		expect(admission.appliable?).to eq true
	end

	it "should be false some time after the shown application deadline" do
		admission = create(:admission,
			shown_application_deadline: 1.hour.ago,
			actual_application_deadline: 1.minute.ago)
		expect(admission.appliable?).to eq false
	end

end
