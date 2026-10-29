# frozen_string_literal: true

require 'rails_helper'
require 'open3'

RSpec.describe 'Time zone configuration during early database loading' do
  it 'keeps PostgreSQL zoned timestamps aware when models connect before Rails initializes' do
    # Production/staging connect Member while evaluating their environment files.
    # The normal test boot loads the adapter later and masks this ordering issue.
    script = <<~RUBY
      require './config/application'
      require './app/models/member'
      Member.establish_connection(YAML.load_file('config/database.yml', aliases: true).fetch('test'))
      Member.connection
      Rails.application.initialize!
      puts "aware_types=" + ActiveRecord::Base.time_zone_aware_types.join(',')
    RUBY

    stdout, stderr, status = Open3.capture3(
      { 'RAILS_ENV' => 'test' }, RbConfig.ruby, '-e', script, chdir: Rails.root.to_s
    )

    expect(status.success?).to be(true), stderr
    types = stdout.lines.find { |line| line.start_with?('aware_types=') }.to_s.strip.delete_prefix('aware_types=').split(',')
    expect(types).to include('datetime', 'timestamptz')
  end
end
