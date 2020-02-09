# frozen_string_literal: true

require 'rails_helper'

describe AdmissionsAdmin::ApplicantsController do
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
      admission.jobs.first.job_applications << applicant2.job_applications

      admission2.jobs.first.job_applications << applicant3.job_applications
      admission2.jobs.first.job_applications << applicant4.job_applications
    end

    it 'should render show_unlogged_applicants template' do
      get :show_unlogged_applicants, params: { admission_id: admission.id }
      expect(response).to render_template :show_unlogged_applicants
    end

    it 'should show applicants from correct admission' do
      get :show_unlogged_applicants, params: { admission_id: admission.id }
      expect(assigns(:admission)).to eq(admission)
    end

    it 'should only show unlogged applicants from current admission vol. I' do
      get :show_unlogged_applicants, params: { admission_id: admission.id }

      expect(assigns(:all_applicants)).to include(applicant1, applicant2)
      expect(assigns(:all_applicants)).not_to include(applicant3, applicant4)
    end

    it 'should only show unlogged applicants from current admission vol. II' do
      get :show_unlogged_applicants, params: { admission_id: admission2.id }

      expect(assigns(:all_applicants)).to include(applicant3, applicant4)
      expect(assigns(:all_applicants)).not_to include(applicant1, applicant2)
    end

    it 'should show all applicants when none have been logged' do
      get :show_unlogged_applicants, params: { admission_id: admission.id }

      expect(assigns(:unlogged_applicants)).to include(applicant1, applicant2)
      expect(assigns(:unlogged_applicants)).not_to include(applicant3, applicant4)
    end

    it 'should not show all applicants when some have been logged already' do
      log_entry = LogEntry.create!(
        admission: admission,
        applicant: applicant1,
        group: applicant1.job_applications.first.job.group,
        member: user,
        log: 'Logged',
      )
      applicant1.log_entries << log_entry
      get :show_unlogged_applicants, params: { admission_id: admission.id }

      expect(assigns(:unlogged_applicants)).to include(applicant2)
      expect(assigns(:unlogged_applicants)).not_to include(applicant1)
    end
  end

  describe 'PATCH #log_single_applicant' do
    let(:admission) { create(:admission_with_jobs) }
    let(:group) { create(:group) }
    let(:applicant) { create(:applicant, :with_job_applications) }

    it 'should correctly log a single applicant' do
      get :show_unlogged_applicants, params: { admission_id: admission.id }
      patch :show_unlogged_applicants, params: {
        admission_id: admission.id,
        applicant_id: applicant.id,
        group_id: group.id,
        log_entry: {
          log: 'Logged'
        }
      }

      expect(response).to have_http_status(302)
    end
  end
end
