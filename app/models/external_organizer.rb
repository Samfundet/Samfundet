# frozen_string_literal: true

class ExternalOrganizer < ApplicationRecord
  has_many :events, as: :organizer
end
