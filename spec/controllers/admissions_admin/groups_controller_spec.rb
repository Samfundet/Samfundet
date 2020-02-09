# frozen_string_literal: true

require 'rails_helper'

describe AdmissionsAdmin::GroupsController do
  describe 'GET #show_unlogged_applicants' do
    let(:admission) { create(:admission_with_jobs) }
    let(:admission2) { create(:admission_with_jobs) }
    let(:user) { create(:member, :with_role, role_title: 'lim_web') }

    let(:applicant1) { create(:applicant, :with_job_applications) }
    let(:applicant2) { create(:applicant, :with_job_applications) }
    let(:applicant3) { create(:applicant, :with_job_applications) }
    let(:applicant4) { create(:applicant, :with_job_applications) }

    before do
      login_member(user)

      admission.jobs.first.job_applications << applicant1.job_applications
      admission.jobs.second.job_applications << applicant2.job_applications

      admission2.jobs.first.job_applications << applicant3.job_applications
      admission2.jobs.second.job_applications << applicant4.job_applications
    end

    it 'should render show_unlogged_applicants template' do
      group_id = admission.jobs.first.group.id
      get :show_unlogged_applicants, params: { admission_id: admission.id, group_id: group_id }
      expect(response).to render_template :show_unlogged_applicants
    end

    it 'should show the groups applicants from the current admission' do
      group_id = admission.jobs.first.group.id
      get :show_unlogged_applicants, params: { admission_id: admission.id, group_id: group_id }

      group = Group.find(group_id)
      expect(assigns(:admission)).to eq(admission)
      expect(assigns(:group)).to eq(group)

      # `unlogged_applicants_grouped` is a hashmap from group to a hashmap that is from job to a list of applicants.
      # i.e.: { group => {job => [applicants]}}
      # Sorry :-)
      applicants = assigns(:unlogged_applicants_grouped).values.flatten[0].values.flatten
      expect(applicants).to include(applicant1)
      expect(applicants).not_to include(applicant2, applicant3, applicant4)

      expect(assigns(:unlogged_applicants)).to include(applicant1)
      expect(assigns(:unlogged_applicants)).not_to include(include(applicant2, applicant3, applicant4))

      expect(assigns(:all_applicants)).to include(applicant1)
      expect(assigns(:all_applicants)).not_to include(applicant3, applicant4)
    end
  end
end
