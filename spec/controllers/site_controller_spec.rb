# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SiteController, type: :controller do
  before do
    Rails.application.config.nybygg_countdown_enabled = false
    Page.create!(name_no: 'aapningstider', name_en: I18n.t('site.index.opening-hours-page-title').downcase, role: Role.super_user)
  end
  it 'shows no banner and no open admissions when there are none' do
    get :index
    expect(assigns(:banner_event)).to be_nil
    expect(assigns(:open_admission)).to be(false)
    expect(assigns(:info_boxes)).to eq({})
  end
  it 'uses the first frontpage event as banner and groups active info boxes by position' do
    event = create(:event, publication_time: 1.day.ago)
    image = event.image
    first = create(:info_box, image: image, start_time: 1.hour.ago, position: 1)
    second = create(:info_box, image: image, start_time: 1.hour.ago, position: 1)
    create(:info_box, image: image, start_time: 1.hour.from_now, position: 2)
    create(:admission)
    get :index
    expect(assigns(:banner_event)).to eq(event)
    expect(assigns(:info_boxes)[1]).to match_array([first, second])
    expect(assigns(:info_boxes)[2]).to be_nil
    expect(assigns(:open_admission)).to be(true)
  end
  it 'computes the new building countdown' do
    travel_to Time.zone.local(2026, 10, 7, 12) do
      Rails.application.config.nybygg_countdown_enabled = true
      Rails.application.config.nybygg_countdown_date = Time.current + 1.day + 2.hours + 3.minutes + 4.seconds
      get :index
      expect([assigns(:days_left), assigns(:hours_left), assigns(:minutes_left), assigns(:seconds_left)]).to eq([1, 2, 3, 4])
    end
  end
  it 'does not compute opening hours during a closure' do
    create(:everything_closed_period)
    get :index
    expect(assigns(:open_now)).to be_nil
  end
  it 'shows known payment errors and a generic error for unknown sessions' do
    BilligPaymentError.create!(error: 'known', message: 'Payment failed')
    get :index, params: { bsession: 'known' }
    expect(flash[:error]).to eq('Payment failed')
    get :index, params: { bsession: 'unknown' }
    expect(flash[:error]).to eq(I18n.t('events.purchase_generic_error'))
  end
  it 'redirects to the election survey' do
    get :generic_redirect
    expect(response).to redirect_to('https://no.surveymonkey.com/r/samfundet-valgundersokelse')
  end
  { brochure: 'samfundet-brosjyre.pdf', strategy: 'samfundet-strategi.pdf', ethical_guidelines: 'samfundet-etiske-retningslinjer.pdf' }.each do |action, filename|
    it "serves #{action} as an inline PDF" do
      expect(controller).to receive(:send_file).with(kind_of(String), filename: filename, disposition: 'inline', type: 'application/pdf')
      controller.public_send(action)
    end
  end
end
