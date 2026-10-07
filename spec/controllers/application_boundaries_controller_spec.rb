# frozen_string_literal: true

require 'rails_helper'
RSpec.describe ApplicationController, type: :controller do
  controller do
    skip_authorization_check
    def index
      render plain: 'ok'
    end
    def denied
      permission_denied
    end
    def invalid
      handle_unverified_request
    end
  end
  before do
    routes.draw do
      get 'index' => 'anonymous#index'
      match 'denied' => 'anonymous#denied', via: %i[get post]
      post 'invalid' => 'anonymous#invalid'
    end
  end
  it 'handles deleted users without returning a stale account' do
    session[:member_id] = -1
    expect(controller.current_user).to be_nil
    session[:member_id] = nil
    session[:applicant_id] = -1
    expect(controller.current_user).to be_nil
  end
  it 'returns empty unauthorized responses to AJAX clients' do
    get :denied, xhr: true
    expect(response).to have_http_status(:unauthorized)
    expect(response.body).to eq('')
  end
  it 'redirects guests to login with their original destination' do
    get :denied
    expect(response).to be_redirect
    expect(flash[:error]).to eq(I18n.t('common.log_in_to_view_page'))
  end
  it 'redirects failed guest POSTs without a referrer to the homepage' do
    post :denied
    expect(response).to be_redirect
  end
  it 'rejects referrers on a different domain even if they include our hostname' do
    request.env['HTTP_REFERER'] = 'https://test.host.attacker.example/path'
    expect(controller.send(:request_referer_if_on_current_domain)).to be_nil
  end
  it 'returns same-domain referrers' do
    request.env['HTTP_REFERER'] = 'https://test.host/path'
    expect(controller.send(:request_referer_if_on_current_domain)).to eq('https://test.host/path')
  end
  it 'returns nil for malformed referrers' do
    request.env['HTTP_REFERER'] = 'not a valid URL'
    expect(controller.send(:request_referer_if_on_current_domain)).to be_nil
  end
  it 'resets session identity after invalid authenticity tokens' do
    session[:member_id] = create(:member).id
    post :invalid
    expect(session[:member_id]).to be_nil
    expect(flash[:error]).to include('error processing your request')
  end
  it 'checks open primary admissions' do
    expect(controller.open_admission?).to be(false)
    create(:admission, is_primary: true)
    expect(controller.open_admission?).to be(true)
  end
end
