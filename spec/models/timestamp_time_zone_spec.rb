# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PostgreSQL timestamp time zone conversion' do
  let(:connection) { ApplicationRecord.connection }
  let(:model) do
    Class.new(ApplicationRecord) do
      self.table_name = 'timestamp_time_zone_regression'
    end
  end

  before do
    # Production uses timestamp without time zone for website events and
    # timestamp with time zone for Billig events. schema.rb loses that distinction.
    connection.execute(<<~SQL)
      CREATE TEMPORARY TABLE timestamp_time_zone_regression (
        id serial PRIMARY KEY,
        website_time timestamp without time zone,
        billig_time timestamp with time zone
      )
    SQL
  end

  after do
    connection.execute('DROP TABLE IF EXISTS timestamp_time_zone_regression')
  end

  {
    'winter' => ['2026-10-29 19:00:00', '+0100'],
    'summer' => ['2026-07-15 18:00:00', '+0200']
  }.each do |season, (utc_time, offset)|
    %w[website_time billig_time].each do |column|
      it "displays #{column} in local time during #{season}" do
        connection.execute(<<~SQL)
          INSERT INTO timestamp_time_zone_regression (website_time, billig_time)
          VALUES (#{connection.quote(utc_time)}, #{connection.quote("#{utc_time}+00")})
        SQL

        value = model.first.public_send(column)

        expect(value).to be_a(ActiveSupport::TimeWithZone)
        expect(I18n.l(value, format: '%H:%M %z')).to eq("20:00 #{offset}")
        expect(value.utc.strftime('%Y-%m-%d %H:%M:%S')).to eq(utc_time)
      end
    end
  end
end
