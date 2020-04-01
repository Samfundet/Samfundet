# frozen_string_literal: true

require 'rspec'
require 'rails_helper'

describe Event do
  it 'should throw exception when created without a publication time' do
    expect do
      create(:event, publication_time: nil)
    end.to raise_error(ActiveRecord::RecordInvalid)
  end
end
