# frozen_string_literal: true

require 'rails_helper'
require Rails.root.join('lib/samfundet_auth')

RSpec.describe SamfundetAuth do
  let(:database_path) { Rails.root.join('config/database.yml').to_s }
  let(:domain_database) { { 'adapter' => 'postgresql', 'database' => 'domain_test' } }
  let(:member_database) { { 'adapter' => 'postgresql', 'database' => 'member_test' } }

  before do
    allow(described_class).to receive(:config).and_return(ActiveSupport::OrderedOptions.new)
    allow(File).to receive(:exist?).and_call_original
    allow(File).to receive(:exist?).with(database_path).and_return(true)
    allow(YAML).to receive(:load_file).with(database_path, aliases: true)
      .and_return('domain' => domain_database, 'members' => member_database)
  end

  it 'leaves existing connections and the member table unchanged when unconfigured' do
    [Role, MembersRole, Member].each { |model| expect(model).not_to receive(:establish_connection) }
    expect(Member).not_to receive(:table_name=)

    described_class.setup { |_config| }
  end

  it 'connects roles to the configured domain database' do
    [Role, MembersRole].each do |model|
      expect(model).to receive(:establish_connection).with(domain_database)
    end
    expect(Member).not_to receive(:establish_connection)

    described_class.setup { |config| config.domain_database = :domain }
  end

  it 'connects members to the configured member database and sets the table name' do
    [Role, MembersRole].each { |model| expect(model).not_to receive(:establish_connection) }
    expect(Member).to receive(:establish_connection).with(member_database)
    expect(Member).to receive(:table_name=).with('custom_members')

    described_class.setup do |config|
      config.member_database = :members
      config.member_table = :custom_members
    end
  end

  it 'allows configuring the member table independently of its connection' do
    expect(Member).not_to receive(:establish_connection)
    expect(Member).to receive(:table_name=).with('custom_members')

    described_class.setup { |config| config.member_table = :custom_members }
  end

  it 'yields configuration but skips database setup when the database file is missing' do
    allow(File).to receive(:exist?).with(database_path).and_return(false)
    expect(YAML).not_to receive(:load_file)
    [Role, MembersRole, Member].each { |model| expect(model).not_to receive(:establish_connection) }
    expect(Member).not_to receive(:table_name=)

    described_class.setup do |config|
      config.domain_database = :domain
      config.member_database = :members
      config.member_table = :custom_members
    end

    expect(described_class.config.member_table).to eq(:custom_members)
  end
end
