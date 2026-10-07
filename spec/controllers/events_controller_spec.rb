# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  let(:event) { create(:event, publication_time: 1.day.ago) }
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
    Rails.application.config.billig_offline = false
  end
  it 'lists only active published upcoming events' do
    event
    create(:event, status: 'canceled', publication_time: 1.day.ago)
    create(:event, publication_time: 1.day.from_now)
    create(:event, publication_time: 3.days.ago, non_billig_start_time: 2.days.ago)
    get :index
    expect(assigns(:events)).to contain_exactly(event)
  end
  %i[show edit].each do |action|
    it "loads an event for #{action}" do
      get action, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
    end
  end
  it 'prepares default event times' do
    get :new
    expect(assigns(:event)).to be_new_record
    expect(assigns(:event).non_billig_start_time).to be > Time.current
  end
  it 'creates an event with an external organizer' do
    source = event
    attrs = source.attributes.except('id', 'created_at', 'updated_at')
    attrs['organizer_external_name'] = 'New organizer'
    expect { post :create, params: { event: attrs } }.to change(Event, :count).by(1)
    expect(assigns(:event).organizer.name).to eq('New organizer')
    expect(response).to redirect_to(assigns(:event))
  end
  it 'rejects incomplete events without persisting them' do
    expect { post :create, params: { event: { title_en: '' } } }.not_to change(Event, :count)
    expect(response).to render_template(:new)
  end
  it 'updates an event' do
    patch :update, params: { id: event.id, event: { title_en: 'New title' } }
    expect(event.reload.title_en).to eq('New title')
    expect(response).to redirect_to(event)
  end
  it 'preserves the original title on invalid updates' do
    title = event.title_en
    patch :update, params: { id: event.id, event: { title_en: '' } }
    expect(event.reload.title_en).to eq(title)
    expect(response).to render_template(:edit)
  end
  it 'deletes an event' do
    event
    expect { delete :destroy, params: { id: event.id } }.to change(Event, :count).by(-1)
    expect(response).to redirect_to(events_path)
  end
  it 'lists upcoming events for administrators' do
    event
    get :admin
    expect(assigns(:events)).to include(event)
  end
  it 'paginates archived events even when the page parameter is invalid' do
    old = create(:event, publication_time: 3.days.ago, non_billig_start_time: 2.days.ago)
    get :archive, params: { page: 'invalid' }
    expect(assigns(:events)).to include(old)
    expect(assigns(:events).current_page).to eq(1)
  end
  it 'redirects empty archive searches and reports a missing result' do
    get :archive_search, params: { search: 'not-found' }
    expect(response).to redirect_to(archive_events_path)
    expect(flash[:error]).to eq(I18n.t('search.no_results'))
  end
  it 'filters the calendar by event type' do
    event.update!(event_type: 'concert')
    get :ical, params: { event_type: 'concert' }, format: :ics
    expect(assigns(:events)).to contain_exactly(event)
  end
  it 'rejects purchases when no tickets can be purchased' do
    get :buy, params: { id: event.id }
    expect(response).to redirect_to(event)
    expect(flash[:error]).to eq(I18n.t('events.can_not_purchase_error'))
  end
  it 'requires the correct codeword before purchasing' do
    event.update!(codeword: 'secret')
    get :buy, params: { id: event.id }
    expect(flash[:error]).to eq(I18n.t('events.please_enter_codeword'))
    get :buy, params: { id: event.id, codeword: 'wrong' }
    expect(flash[:error]).to eq(I18n.t('events.wrong_codeword'))
  end
  it 'redirects unknown failed payment sessions to the home page' do
    get :purchase_callback_failure, params: { bsession: 'unknown' }
    expect(response).to redirect_to(root_path(bsession: 'unknown'))
    expect(flash[:error]).to eq(I18n.t('events.purchase_generic_error'))
  end
end

RSpec.describe EventsController, type: :controller do
  before do
    member = create(:member)
    member.roles << Role.super_user
    login_member(member)
  end
  it 'searches upcoming events and renders AJAX search results' do
    event = create(:event, non_billig_title_no: 'Special concert', title_en: 'Special concert', publication_time: 1.day.ago)
    get :search, params: { search: 'Special' }, xhr: true
    expect(assigns(:events)).to include(event)
    expect(response).to render_template('_search_results')
  end
  it 'paginates nonempty archive searches' do
    event = create(:event, non_billig_title_no: 'Special concert', title_en: 'Special concert', publication_time: 3.days.ago, non_billig_start_time: 2.days.ago)
    get :archive_search, params: { search: 'Special', page: 'bad' }
    expect(assigns(:events)).to include(event)
    expect(assigns(:events).current_page).to eq(1)
    expect(response).to render_template('_archive_list')
  end
  it 'exports current or archived events as RSS' do
    upcoming = create(:event, publication_time: 1.day.ago)
    past = create(:event, publication_time: 3.days.ago, non_billig_start_time: 2.days.ago)
    get :rss, format: :rss
    expect(assigns(:events)).to include(upcoming)
    expect(assigns(:events)).not_to include(past)
    get :rss, params: { type: 'archive' }, format: :rss
    expect(assigns(:events)).to include(past, upcoming)
  end
  it 'exports all event types when no calendar type is specified' do
    event = create(:event, publication_time: 1.day.ago)
    get :ical, format: :ics
    expect(assigns(:events)).to include(event)
  end
end
