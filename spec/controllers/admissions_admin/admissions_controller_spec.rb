# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AdmissionsAdmin::AdmissionsController, type: :controller do
  let(:admin) { create(:member) }
  let(:admission) { create(:admission) }
  before do
    admin.roles << Role.super_user
    login_member(admin)
  end
  it 'lists current, future and completed admissions separately' do
    admission
    get :list
    expect(assigns(:open_admissions)).to include(admission)
    expect(assigns(:closed_admissions)).to be_empty
    expect(assigns(:upcoming_admissions)).to be_empty
  end
  it 'starts a new admission using the existing promotional video' do
    admission
    get :new
    expect(assigns(:admission)).to be_new_record
    expect(assigns(:admission).promo_video).to eq(admission.promo_video)
  end
  it 'creates a valid admission' do
    expect { post :create, params: { admission: attributes_for(:admission) } }.to change(Admission, :count).by(1)
    expect(response).to redirect_to(admissions_path)
  end
  it 'rejects incomplete admissions' do
    expect { post :create, params: { admission: { title: '' } } }.not_to change(Admission, :count)
    expect(response).to render_template(:new)
  end
  it 'loads an admission for editing' do
    get :edit, params: { id: admission.id }
    expect(assigns(:admission)).to eq(admission)
  end
  it 'updates admission attributes' do
    patch :update, params: { id: admission.id, admission: { title: 'Updated' } }
    expect(admission.reload.title).to eq('Updated')
    expect(response).to redirect_to(admissions_path)
  end
  it 'rejects invalid admission changes without persisting them' do
    title = admission.title
    patch :update, params: { id: admission.id, admission: { title: '' } }
    expect(admission.reload.title).to eq(title)
    expect(response).to render_template(:edit)
  end
  it 'shows the groups available to the current administrator' do
    group = create(:group)
    get :show, params: { id: admission.id }
    expect(assigns(:my_groups)).to contain_exactly(group)
    expect(response).to redirect_to(admissions_admin_admission_group_path(admission, group))
  end
  describe 'application statistics and rejection mail' do
    let(:job) { create(:job, admission: admission) }
    let!(:rejected) { create(:job_application, job: job) }
    let!(:accepted) { create(:job_application, job: job) }
    before do
      rejected.find_or_create_interview.update!(priority: :not_wanted, applicant_status: :rejected)
      accepted.find_or_create_interview.update!(priority: :wanted, applicant_status: :accepted)
    end
    it 'counts unique applicants and completed outcomes' do
      get :overview, params: { id: admission.id }
      expect(assigns(:total_applications)).to eq(2)
      expect(assigns(:total_processed)).to eq(2)
      expect(assigns(:total_unique_applicants)).to eq(2)
      expect(assigns(:total_unique_accepted)).to eq(1)
      expect(assigns(:total_unique_rejected)).to eq(1)
      expect(assigns(:admission_complete)).to be(true)
    end
    it 'builds charts using actual applications and accepted outcomes' do
      LogEntry.create!(admission: admission, applicant: accepted.applicant, group: job.group, member: admin, log: LogEntry.acceptance_log_entry)
      get :statistics, params: { id: admission.id }
      expect(assigns(:total_applicants).size).to eq(2)
      expect(assigns(:total_accepted_applicants)).to eq([accepted.applicant])
      expect(assigns(:ratio)).to eq(50.0)
      expect(assigns(:applications_per_day).map(&:last).sum).to eq(2)
      expect(assigns(:applications_per_hour).map(&:last).sum).to eq(2)
      expect(assigns(:applicants)[job.group][:ratio]).to eq(50.0)
      expect(assigns(:applications_per_group_chart)).to be_a(LazyHighCharts::HighChart)
    end
    it 'previews rejection mail only for rejected applicants not already emailed' do
      get :review_rejection_email, params: { id: admission.id, subject: 'Result', introduction: 'Hello', content: 'Thank you' }
      expect(assigns(:recipients)).to eq([rejected.applicant])
      expect(assigns(:template)).to eq(subject: 'Result', intro: 'Hello', content: 'Thank you')
    end
    it 'excludes applicants already sent a rejection email' do
      RejectionEmail.create!(admission: admission, applicant: rejected.applicant, sent_at: Time.current)
      get :review_rejection_email, params: { id: admission.id }
      expect(assigns(:recipients)).to be_empty
    end
    it 'prepares rejection sending with the submitted template' do
      get :send_rejection_email, params: { id: admission.id, subject: 'Result', intro: 'Hello', content: 'Thank you' }
      expect(assigns(:recipients)).to eq([rejected.applicant])
      expect(assigns(:template)[:subject]).to eq('Result')
    end
    it 'delivers rejection mail once and records it' do
      expect { post :send_rejection_email_result, params: { id: admission.id, subject: 'Result', intro: 'Hello', content: 'Thank you' } }.to change(RejectionEmail, :count).by(1)
      expect(assigns(:success)).to eq([rejected.applicant])
      expect(assigns(:failure)).to be_empty
      expect(ActionMailer::Base.deliveries.last.to).to eq([rejected.applicant.email])
    end
    it 'lists sent rejection emails and finds missing recipients' do
      RejectionEmail.create!(admission: admission, applicant: accepted.applicant, sent_at: Time.current)
      get :overview, params: { id: admission.id }
      expect(assigns(:missing)).to eq([rejected.applicant.id])
      get :rejection_email_list, params: { id: admission.id }
      expect(assigns(:rejection_emails).map(&:applicant)).to eq([accepted.applicant])
    end
  end
end
