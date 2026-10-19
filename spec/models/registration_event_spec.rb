# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'RegistrationEvent external registration adapter' do
  before do
    # The registration database is external. Exercise the adapter against a
    # controlled query response, without opening a production connection.
    allow(ActiveRecord::Base).to receive(:establish_connection).with(:paamelding).and_return(nil)
    load Rails.root.join('app/models/registration_event.rb') unless defined?(RegistrationEvent)
  end
  it 'reads registration totals and generates the external signup link' do
    event = RegistrationEvent.allocate
    event.define_singleton_method(:arrangement_id) { 42 }
    connection = double('registration database')
    allow(RegistrationEvent).to receive(:connection).and_return(connection)
    expect(connection).to receive(:exec_query).with('SELECT * FROM paameldingsys.lim_paameldingsinfo WHERE arrangement_id=42;').and_return(ActiveRecord::Result.new(['paameldinger'], [[3]]))
    expect(event.registrations).to eq(3)
    expect(event.link).to eq('https://medlem.samfundet.no/account/paamelding?id=42')
  end
  it 'checks capacity while allowing missing totals or limits' do
    event = RegistrationEvent.allocate
    event.define_singleton_method(:plasser) { 3 }
    allow(event).to receive(:registrations).and_return(3)
    expect(event.full?).to be(true)
    allow(event).to receive(:registrations).and_return(2)
    expect(event.full?).to be(false)
    allow(event).to receive(:registrations).and_return(nil)
    expect(event.full?).to be(false)
  end
end
