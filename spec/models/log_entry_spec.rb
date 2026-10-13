# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LogEntry do
  it 'requires log text and all participants' do
    log = LogEntry.new
    expect(log).not_to be_valid
    %i[log admission group applicant member].each { |field| expect(log.errors[field]).to be_present }
  end
  it 'identifies an acceptance log without treating other logs as acceptance' do
    expect(LogEntry.possible_log_entries.length).to eq(7)
    expect(LogEntry.new(log: LogEntry.acceptance_log_entry)).to be_is_acceptance_log_entry
    expect(LogEntry.new(log: LogEntry.possible_log_entries.first)).not_to be_is_acceptance_log_entry
  end
end
