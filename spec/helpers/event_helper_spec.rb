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
end
