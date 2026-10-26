# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventHelper, type: :helper do
  describe '#inline_event_price' do
    let(:prices) do
      [double('guest price', price: 150, name: 'Guest'),
       double('member price', price: 100, name: 'Member')]
    end

    it 'sorts custom prices from cheapest to most expensive and includes names' do
      event = instance_double(Event, price_type: 'custom', price: prices)

      expect(helper.inline_event_price(event)).to eq('100,- Member / 150,- Guest')
    end

    it 'sorts Billig prices without displaying names' do
      event = instance_double(Event, price_type: 'billig', price: prices)

      expect(helper.inline_event_price(event)).to eq('100,- / 150,-')
    end

    it 'returns an empty string when no custom prices are available' do
      event = instance_double(Event, price_type: 'custom', price: [])

      expect(helper.inline_event_price(event)).to eq('')
    end

    { 'free' => 'ticket_free', 'free_registration' => 'free_registration',
      'included' => 'ticket_included' }.each do |price_type, translation|
      it "uses the translated label for #{price_type} tickets" do
        event = instance_double(Event, price_type: price_type)

        I18n.with_locale(:en) do
          expect(helper.inline_event_price(event)).to eq(I18n.t("events.#{translation}"))
        end
      end
    end
  end

  describe '#from_to_string' do
    it 'formats both event times in the current locale' do
      event = instance_double(Event, start_time: Time.zone.local(2026, 10, 6, 18, 30),
                                    end_time: Time.zone.local(2026, 10, 6, 20, 45))

      I18n.with_locale(:no) do
        expect(helper.from_to_string(event)).to eq(
          "#{I18n.l(event.start_time, format: :time)} - #{I18n.l(event.end_time, format: :time)}"
        )
      end
    end
  end
  describe '#organizer_link' do
    it 'links groups and renders linked external organizers' do
      group = Group.new
      group_event = instance_double(Event, organizer: group)
      allow(helper).to receive(:group_link).with(group).and_return('Group link')
      expect(helper.organizer_link(group_event)).to eq('Group link')

      external_event = instance_double(
        Event,
        organizer: double(name: 'Organizer'),
        external_organizer?: true,
        external_organizer_link: 'https://example.com'
      )
      allow(helper).to receive(:render)
        .with('events/external_organizer_link', event: external_event)
        .and_return('External organizer link')
      expect(helper.organizer_link(external_event)).to eq('External organizer link')
    end

    it 'returns the organizer name when no external link is available' do
      organizer = double(name: 'Organizer')
      event = instance_double(Event, organizer: organizer, external_organizer?: true, external_organizer_link: '')

      expect(helper.organizer_link(event)).to eq('Organizer')
    end
  end

  it 'translates event type and age limit and embeds the YouTube video' do
    event = instance_double(Event, event_type: 'music', age_limit: 18, youtube_embed: 'https://youtube.com/watch?v=abc123')
    allow(helper).to receive(:t).with('events.music').and_return('Music')
    allow(helper).to receive(:t).with('events.18').and_return('18+')

    expect(helper.t_event_type(event)).to eq('Music')
    expect(helper.t_event_age_limit(event)).to eq('18+')
    expect(helper.embed(event)).to include('src="//www.youtube.com/embed/abc123"')
  end

  it 'builds event and front-page cache keys from their inputs' do
    event = build(:event)
    user = double('current user')
    helper.define_singleton_method(:current_user) { user }

    expect(helper.cache_key_for_event_show(event)).to eq([I18n.locale, 'event_show', event, user])
    expect(helper.cache_key_for_events_index([event])).to eq([I18n.locale, 'events_index', [event], Time.current.day])
    expect(helper.cache_key_for_frontpage_events([event])).to eq([I18n.locale, 'site/frontpage-empty', [event], user])
    expect(helper.cache_key_for_frontpage_event(event, 0)).to eq([I18n.locale, 'frontpage_event', event, 0, user])
    expect(helper.cache_key_for_banner_event(event)).to eq([I18n.locale, 'banner_event', event])
  end
end
