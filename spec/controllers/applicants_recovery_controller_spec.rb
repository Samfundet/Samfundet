# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ApplicantsController, type: :controller do
  let(:applicant) { create(:applicant) }
  it 'sends recovery instructions for a known email' do
    expect { post :generate_forgot_password_email, params: { applicant_login_field: applicant.email } }.to change(PasswordRecovery, :count).by(1)
    expect(ActionMailer::Base.deliveries.last.to).to eq([applicant.email])
    expect(response).to redirect_to(applicant_login_path)
  end
  it 'finds accounts by phone number' do
    post :generate_forgot_password_email, params: { applicant_login_field: applicant.phone }
    expect(assigns(:applicant)).to eq(applicant)
  end
  it 'rejects unknown accounts without creating recovery tokens' do
    expect { post :generate_forgot_password_email, params: { applicant_login_field: 'unknown@example.com' } }.not_to change(PasswordRecovery, :count)
    expect(flash[:error]).to eq(I18n.t('applicants.password_recovery.field_unknown'))
  end
  it 'rejects excessive password recovery attempts' do
    5.times { PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'token') }
    post :generate_forgot_password_email, params: { applicant_login_field: applicant.email }
    expect(flash[:error]).to eq(I18n.t('applicants.password_recovery.limit_reached'))
  end
  it 'shows a reset form only for a valid recovery token' do
    PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'token')
    get :reset_password, params: { email: applicant.email, hash: 'token' }
    expect(assigns(:applicant)).to eq(applicant)
    expect(assigns(:hash)).to eq('token')
    expect(assigns(:email)).to eq(applicant.email)
  end
  it 'rejects invalid and missing recovery tokens' do
    get :reset_password, params: { email: applicant.email, hash: 'wrong' }
    expect(assigns(:applicant)).to be_nil
    expect(flash[:error]).to eq(I18n.t('applicants.password_recovery.hash_error'))
  end
  it 'changes the password and consumes the token' do
    PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'token')
    expect { post :change_password, params: { id: applicant.id, hash: 'token', applicant: { password: 'changed-password', password_confirmation: 'changed-password' } } }.to change(PasswordRecovery, :count).by(-1)
    expect(Applicant.authenticate(applicant.email, 'changed-password')).to eq(applicant)
    expect(response).to redirect_to(applicant_login_path)
  end
  it 'retains the token when new passwords do not match' do
    PasswordRecovery.create!(applicant_id: applicant.id, recovery_hash: 'token')
    post :change_password, params: { id: applicant.id, email: applicant.email, hash: 'token', applicant: { password: 'changed-password', password_confirmation: 'different' } }
    expect(response).to render_template(:reset_password)
    expect(PasswordRecovery.count).to eq(1)
  end
  it 'does not change a password with an invalid token' do
    original = applicant.hashed_password
    post :change_password, params: { id: applicant.id, hash: 'wrong', applicant: { password: 'changed-password', password_confirmation: 'changed-password' } }
    expect(applicant.reload.hashed_password).to eq(original)
    expect(assigns(:applicant)).to be_nil
  end
  it 'verifies an email only once' do
    EmailVerification.create!(applicant: applicant, verification_hash: 'token')
    get :verify_email, params: { applicant: applicant.id, hash: 'token' }
    expect(applicant.reload).to be_verified
    expect(EmailVerification.count).to eq(0)
    expect(response).to redirect_to(applicant_login_path)
  end
  it 'rejects invalid email verification tokens' do
    get :verify_email, params: { applicant: applicant.id, hash: 'wrong' }
    expect(applicant.reload).not_to be_verified
    expect(flash[:error]).to eq(I18n.t('applicants.email_verification.verification_link_invalid'))
  end
  it 'includes the admission destination when verifying an email' do
    admission = create(:admission)
    EmailVerification.create!(applicant: applicant, verification_hash: 'token')
    get :verify_email, params: { applicant: applicant.id, hash: 'token', admission: admission.id }
    expect(response).to redirect_to(applicant_login_path(redirect_to: admission_path(admission.id)))
  end
  it 'rejects Microsoft addresses when the filter is enabled' do
    allow(Rails.application.config).to receive(:enable_microsoft_email_filter).and_return(true)
    attrs = attributes_for(:applicant, email: 'test@hotmail.com', campus_id: create(:campus).id)
    expect { post :create, params: { applicant: attrs } }.not_to change(Applicant, :count)
    expect(response).to render_template(:new)
    expect(flash[:error]).to eq(I18n.t('applicants.forms.register.microsoft_warning'))
  end
  it 'searches applicants by name and email' do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
    applicant
    get :search, params: { term: applicant.email }, format: :json
    expect(JSON.parse(response.body).first['value']).to include(applicant.full_name)
  end
end
