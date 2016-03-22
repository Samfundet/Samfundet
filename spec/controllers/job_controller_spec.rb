require 'rails_helper'

describe JobsController do
  describe "GET #show" do
    let(:job) { create(:job)}
    let(:similar_job) { create(:job)}

    before do
      #@job = create(:job)
      #@similar_job = create(:job)
      allow(Job).to receive(:find) { job }
      allow(job).to receive(:similar_available_jobs) { [similar_job] }
      allow(job).to receive(:available_jobs_in_same_group) { [similar_job] }
      t = job.similar_available_jobs
    end

    it "renders the new template with admissions layout" do
      get :show, id: job.id
      expect(response).to render_template(:show)
      expect(response).to render_template(layout: "admissions")
    end

    it "assigns job" do
      get :show, id: job.id
      expect(assigns(:job)).to eq job
    end

    it "assigns similar available jobs" do
      get :show, id: job.id
      expect(assigns(:similar_available_jobs)).to eq([similar_job])
    end

    it "assigns available jobs in same group" do
      get :show, id: job.id
      expect(assigns(:available_jobs_in_same_group)).to eq([similar_job])
    end

    context "when logged in as an applicant" do
      let(:applicant) { create(:applicant)}
      before do
        login_applicant(applicant)
      end
      context "the applicant has already applied to this job" do

        let(:application) {create(:job_application, applicant: applicant, job: job)}

        it "assigns job_application returns existing applicaion" do
          get :show, id: application.job.id

          expect(assigns(:job_application)).to eq application
        end

        it "assigns @already_applied to true" do
          get :show, id: application.job.id

          expect(assigns(:already_applied)).to be true
        end
      end

      context "the applicant has not applied to this job" do
        it "assigns job_application to a new record" do
          get :show, id: job.id

          expect(assigns(:job_application)).to be_new_record
        end

        it "assigns @already_applied to false" do
          get :show, id: job.id

          expect(assigns(:already_applied)).to be false
        end
      end
    end

    context "when not logged in as an applicant" do
      it "assigns job_application to a new record" do
        get :show, id: job.id

        expect(assigns(:job_application)).to be_new_record
      end

      it "assigns @already_applied to false" do
        get :show, id: job.id

        expect(assigns(:already_applied)).to be false
      end
    end

  end
end