# frozen_string_literal: true

module Types
  class OrganizerType < BaseUnion
    description 'Organizer of an event'
    possible_types GroupType, ExternalOrganizerType
  end
end
