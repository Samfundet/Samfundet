# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventHelper, type: :helper do
  before { helper.define_singleton_method(:current_user) { nil } }
  let(:event) { build(:event) }
  it 'includes locale, user and event identity in cache keys' do
    expect(helper.cache_key_for_event_show(event)).to eq([I18n.locale, 'event_show', event, nil])
    expect(helper.cache_key_for_events_index([event])).to eq([I18n.locale, 'events_index', [event], Time.current.day])
    expect(helper.cache_key_for_frontpage_events([event])).to eq([I18n.locale, 'site/frontpage-empty', [event], nil])
    expect(helper.cache_key_for_frontpage_event(event, 2)).to eq([I18n.locale, 'frontpage_event', event, 2, nil])
    expect(helper.cache_key_for_banner_event(event)).to eq([I18n.locale, 'banner_event', event])
  end
  it 'translates event type and age restriction labels' do
    expect(helper.t_event_type(event)).to eq(I18n.t("events.#{event.event_type}"))
    expect(helper.t_event_age_limit(event)).to be_html_safe
  end
  it 'embeds the selected YouTube video in an iframe' do
    event.youtube_embed = 'https://www.youtube.com/watch?v=abc123'
    expect(helper.embed(event)).to include('src="//www.youtube.com/embed/abc123"')
  end
  it 'uses the organizer name for external organizers without links' do
    expect(helper.organizer_link(event)).to eq('NTNU')
  end
  it 'renders a group organizer link' do
    event.organizer = build(:group)
    helper.extend(GroupHelper)
    expect(helper).to receive(:group_link).with(event.organizer).and_return('group link')
    expect(helper.organizer_link(event)).to eq('group link')
  end
  it 'renders the external organizer link when supplied' do
    event.external_organizer_link = 'https://example.com'
    expect(helper).to receive(:render).with('events/external_organizer_link', event: event).and_return('external link')
    expect(helper.organizer_link(event)).to eq('external link')
  end
end
