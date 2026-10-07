# frozen_string_literal: true

require 'rails_helper'
RSpec.describe AdmissionGroupsHelper, type: :helper do
  it 'links to the admission when no group is supplied' do
    admission = create(:admission)
    expect(helper.my_group_path(admission, nil)).to eq(admissions_admin_admission_path(admission))
  end
  it 'links to the selected group within the admission' do
    admission = create(:admission)
    group = create(:group)
    expect(helper.my_group_path(admission, group)).to eq(admissions_admin_admission_group_path(admission, group))
  end
end
