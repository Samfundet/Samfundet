# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExternalOrganizer do
  it 'finds its events through the polymorphic organizer association' do
    organizer = ExternalOrganizer.create!(name: 'NTNU')
    event = create(:event, organizer: organizer)
    create(:event, organizer: create(:group))
    expect(organizer.events).to contain_exactly(event)
  end
end
