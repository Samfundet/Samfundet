# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Event do
  let(:event) { build(:event) }
  before { allow(Rails.application.config).to receive(:billig_offline).and_return(false) }
  it 'computes duration and whether an event has ended' do
    event.non_billig_start_time = 1.hour.ago
    event.duration = 30
    expect(event.end_time).to eq(event.start_time + 30.minutes)
    expect(event).to be_over
    expect(event.ticket_fee).to eq(0)
    expect(event.area_title).to eq(event.area.name)
    expect(event.to_s).to eq(event.title)
  end
  it 'uses Billig time, venue and fee when present' do
    billig = BilligEvent.new(event_time: 1.day.from_now, event_location: 'Venue', ticket_fee: 25)
    event.billig_event = billig
    expect(event.start_time).to eq(billig.event_time)
    expect(event.area_title).to eq('Venue')
    expect(event.ticket_fee).to eq(25)
  end
  it 'generates readable URLs with an ID fallback' do
    event.id = 4
    event.title_en = 'Live Music'
    expect(event.to_param).to eq('4-live-music')
    event.title_en = event.non_billig_title_no = nil
    expect(event.to_param).to eq('4')
  end
  it 'distinguishes group and external organizers' do
    expect(event.external_organizer?).to be(true)
    expect(event.organizer_external_name).to eq('NTNU')
    expect(event.organizer_group_id).to be_nil
    event.organizer = create(:group)
    expect(event.external_organizer?).to be(false)
    expect(event.organizer_group_id).to eq(event.organizer.id)
    expect(event.organizer_external_name).to be_nil
  end
  %w[included free free_registration].each do |type|
    it "has no ticket prices for #{type} events" do
      event.price_type = type
      expect(event.price).to be_nil
    end
  end
  it 'returns custom price groups and clears obsolete ticket associations' do
    event.price_type = 'custom'
    event.price_groups.build(name: 'Member', price: 100)
    expect(event.price.map(&:price)).to eq([100])
    event.enforce_price_choice
    expect(event.billig_event).to be_nil
    event.price_type = 'free'
    event.enforce_price_choice
    expect(event.price_groups).to be_empty
  end
  it 'falls back to the default image if no image is selected' do
    expect(event.image_or_default).to eq(event.image.image_file)
    event.image = nil
    default = Image.new
    allow(Image).to receive(:default_image).and_return(default)
    expect(event.image_or_default).to eq(default.image_file)
  end
  describe 'ticket availability' do
    let(:billig) { BilligEvent.new(sale_from: 1.hour.ago, sale_to: 1.hour.from_now) }
    let(:group) { BilligTicketGroup.new(num: 100, num_sold: 0, ticket_limit: 3) }
    before do
      event.billig_event = billig
      allow(billig).to receive(:netsale_billig_ticket_groups).and_return([group])
      allow(billig).to receive(:billig_ticket_groups).and_return([group])
      allow(group).to receive(:netsale_billig_price_groups).and_return([BilligPriceGroup.new(price: 100)])
    end
    it 'offers tickets only during the sale period' do
      expect(event.purchase_status).to eq(Event::TICKETS_AVAILABLE)
      billig.sale_to = 1.minute.ago
      expect(event.purchase_status).to eq(Event::TICKETS_UNAVAILABLE)
    end
    it 'reports sold out and few tickets at the appropriate thresholds' do
      group.num_sold = 80
      expect(event.few_tickets_left?).to be(true)
      group.num_sold = 100
      expect(event.purchase_status).to eq(Event::TICKETS_SOLD_OUT)
    end
    it 'reports unavailable when the service is offline or no groups are on sale' do
      allow(Rails.application.config).to receive(:billig_offline).and_return(true)
      expect(event.purchase_status).to eq(Event::TICKETS_UNAVAILABLE)
      allow(Rails.application.config).to receive(:billig_offline).and_return(false)
      allow(billig).to receive(:netsale_billig_ticket_groups).and_return([])
      expect(event.purchase_status).to eq(Event::TICKETS_UNAVAILABLE)
    end
    it 'counts limits only from unsold online ticket groups' do
      expect(event.ticket_limit?).to be(true)
      expect(event.total_ticket_limit).to eq(3)
      group.num_sold = 100
      expect(event.total_ticket_limit).to eq(0)
      group.ticket_limit = nil
      expect(event.total_ticket_limit).to eq(0)
    end
    it 'deduplicates online price groups by price' do
      event.price_type = 'billig'
      groups = [BilligPriceGroup.new(price: 100), BilligPriceGroup.new(price: 100), BilligPriceGroup.new(price: 200)]
      allow(group).to receive(:netsale_billig_price_groups).and_return(groups)
      expect(event.price.map(&:price)).to eq([100, 200])
      event.billig_event = nil
      expect(event.price).to eq([])
    end
  end
  describe '#front_page_weight' do
    it 'prioritizes concerts and major venues over quizzes' do
      event.non_billig_start_time = Time.current
      event.event_type = 'concert'
      event.area.name = 'Storsalen'
      expect(event.front_page_weight).to eq(63)
      event.event_type = 'theme_party'
      expect(event.front_page_weight).to eq(65)
      event.event_type = 'quiz'
      expect(event.front_page_weight).to eq(-184)
      event.event_type = 'movie'
      expect(event.front_page_weight).to eq(56)
    end
  end
  it 'filters archived events and provides distinct sorted venues' do
    old = create(:event, non_billig_start_time: 2.days.ago, publication_time: 3.days.ago)
    create(:event, publication_time: 1.day.ago)
    events, types, areas = Event.archived_events_types_areas
    expect(events).to contain_exactly(old)
    expect(types).to eq(types.sort.uniq)
    expect(areas).to eq(areas.sort.uniq)
  end
  it 'returns no results for a blank search' do
    expect(Event.text_search('')).to eq([])
  end
end

RSpec.describe Event do
  it 'incorporates sold-out and low-stock ticket states in frontpage ranking' do
    event = build(:event, event_type: 'movie', non_billig_start_time: Time.current)
    allow(event).to receive(:purchase_status).and_return(Event::TICKETS_SOLD_OUT)
    allow(event).to receive(:few_tickets_left?).and_return(true)
    expect(event.front_page_weight).to eq(-67)
  end
  it 'uses registration capacity and signup URL when supplied' do
    event = build(:event)
    registration = double('registration', full?: false, link: 'https://registration.example/')
    allow(event).to receive(:registration_event).and_return(registration)
    expect(event.full?).to be(false)
    expect(event.link).to eq('https://registration.example/')
    allow(event).to receive(:registration_event).and_return(nil)
    expect(event.full?).to be(true)
    expect(event.link).to eq('')
  end
  it 'includes ticket availability in its cache key' do
    event = build(:event)
    allow(event).to receive(:purchase_status).and_return(Event::TICKETS_AVAILABLE)
    allow(event).to receive(:few_tickets_left?).and_return(true)
    expect(event.cache_key).to include('tickets_available-true')
  end
  it 'defaults group limits according to the number of online price groups' do
    event = build(:event)
    limited = BilligTicketGroup.new(num: 10, num_sold: 0, ticket_limit: 2)
    unlimited = BilligTicketGroup.new(num: 10, num_sold: 0)
    allow(unlimited).to receive(:netsale_billig_price_groups).and_return([BilligPriceGroup.new, BilligPriceGroup.new])
    allow(limited).to receive(:netsale_billig_price_groups).and_return([])
    billig = BilligEvent.new
    allow(billig).to receive(:ticket_limit?).and_return(true)
    allow(billig).to receive(:netsale_billig_ticket_groups).and_return([limited, unlimited])
    event.billig_event = billig
    expect(event.total_ticket_limit).to eq(20)
  end
  it 'clears incompatible prices when switching to included or registration events' do
    %w[included free_registration].each do |type|
      event = build(:event, price_type: type)
      event.price_groups.build(name: 'Guest', price: 100)
      event.billig_event = BilligEvent.new
      event.enforce_price_choice
      expect(event.price_groups).to be_empty
      expect(event.billig_event).to be_nil
    end
    event = build(:event, price_type: 'billig')
    event.price_groups.build(name: 'Guest', price: 100)
    event.enforce_price_choice
    expect(event.price_groups).to be_empty
  end
end

RSpec.describe Event do
  it 'ranks upcoming published events by frontpage weight' do
    concert = create(:event, event_type: 'concert', publication_time: 1.day.ago)
    quiz = create(:event, event_type: 'quiz', publication_time: 1.day.ago)
    expect(Event.by_frontpage_weight).to eq([concert, quiz])
  end
end
