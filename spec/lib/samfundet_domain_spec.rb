# frozen_string_literal: true

require 'rails_helper'

require Rails.root.join('lib/samfundet_domain')
RSpec.describe SamfundetDomain do
  after { SamfundetDomain.config.domain_database = nil }
  it 'does not change connections unless a domain database is configured' do
    [Area, Group, GroupType].each { |model| expect(model).not_to receive(:establish_connection) }
    allow(YAML).to receive(:load_file).and_return({})
    SamfundetDomain.setup { |config| config.domain_database = nil }
  end
  it 'configures all domain models with the selected database' do
    db = { 'adapter' => 'postgresql', 'database' => 'domain_test' }
    allow(YAML).to receive(:load_file).and_return('test' => db)
    [Area, Group, GroupType].each { |model| expect(model).to receive(:establish_connection).with(db) }
    SamfundetDomain.setup { |config| config.domain_database = :test }
  end
  it 'does not read a missing database file' do
    path = Rails.root.join('config/database.yml').to_s
    allow(File).to receive(:exist?).with(path).and_return(false)
    expect(YAML).not_to receive(:load_file)
    SamfundetDomain.setup { |config| config.domain_database = :test }
  end
end
