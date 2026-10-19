# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionsAdmin::ApplicantsController, type: :controller do
  let(:admin) { create(:member) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  let(:admission) { create(:admission) }
  %i[show_interested_other_positions show_applicants_missing_interviews show_unflagged_applicants].each do |action|
    it "loads applicants for #{action}" do
      get action, params: { admission_id: admission.id }
      expect(assigns(:admission)).to eq(admission)
      expect(assigns(:applicants)).to eq([])
    end
  end
  it 'loads the selected applicant for editing' do
    applicant = create(:applicant)
    controller.params = ActionController::Parameters.new(applicant_id: applicant.id)
    controller.edit_applicant
    expect(assigns(:applicant)).to eq(applicant)
  end
end
